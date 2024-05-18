//
//  ShelterListViewController.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Kingfisher

//struct CellInfo: Hashable, Decodable {
////    var title: String
//    var profile: String
//}

struct ImageHeight {
    let url: String
    let imageHeight: CGFloat?
}

class ShelterListViewController: BaseViewController {

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth: CGFloat = (view.bounds.width - 10) / 2
//        let url = URL(string: list[indexPath.item].popfile)!
//     //   var itemSize = CGSize(width: 0, height: 0)
//        var imageRatio: Double = 0
//        downloadImageAndRetrieveSize(from: url) { image, size in
//            //itemSize = size ?? CGSize(width: 0, height: 0)
//            guard let size = size else { return }
//            imageRatio = size.width / size.height
//            print(imageRatio, cellWidth, "이거 돼야해,,ㅠㅠ")
//        }
//        return CGSize(width: cellWidth, height: CGFloat(imageRatio) * cellWidth)
//    }
    
    enum Section: Int, CaseIterable {
        case main
    }

    let mainView = ShelterListView()
    let viewModel = ShelterListViewModel()
    
    var list: [Item] = [] 
    var heightList: [CGFloat] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var itemList = PublishRelay<[Item]>()
    var pagination = PublishRelay<Void>()
    var trigger: () = ()
    let group = DispatchGroup()
    var nextPage: Int = 1
    var pinterestLayout: PinterestLayout!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trigger = ()
    }
    
    func createPinterestLayout(heightList: [CGFloat]) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.1), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            print(sectionIndex)
            let groupHeight = heightList.isEmpty ? 200 : heightList[sectionIndex]
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(groupHeight))
               let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
               let layout = NSCollectionLayoutSection(group: group)
               return layout
           }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureDataSource()
       // updateSnapshot()
       // sectionSnapshot()
        mainView.collectionView.register(ShelterCollectionViewCell.self, forCellWithReuseIdentifier: "ShelterCollectionViewCell")
       
        mainView.collectionView.rx.willDisplayCell
            .subscribe { [weak self] cell, indexPath in
                guard let self = self else { return }
                let value = self.nextPage * 20 - 6
                if value == indexPath.item {
                    self.pagination.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        
    }

    override func loadView() {
        view = mainView
    }

    override func bind() {
        let inputTrigger = BehaviorRelay(value: trigger)
        
        let input = ShelterListViewModel.Input(Trigger: inputTrigger.asObservable(), paginationTrigger: pagination.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.itemList
            .subscribe(with: self) { owner, response in
                owner.list = response
               // owner.itemList.accept(owner.list)
                owner.heightList = .init(repeating: 0, count: owner.list.count)
                print("되긴함", owner.list.count)
                //owner.mainView.collectionView.reloadData()
               // self.updateSnapshot()
                if owner.list.count == 0 {
                    self.updateSnapshot()
                } else {
                    self.sectionSnapshot()
                }
            }
            .disposed(by: disposeBag)
        
        output.nextPage
            .drive(with: self) { owner, value in
                owner.nextPage = value - 1
            }
            .disposed(by: disposeBag)
    }
}

//compositional Layout
extension ShelterListViewController {
    private func cellRegistration() -> UICollectionView.CellRegistration<ShelterCollectionViewCell, Item> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.updateUI(item: itemIdentifier)
        }
    }
    
    private func configureDataSource() {
           let cellRegistration = cellRegistration()
   
           dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
   
               if let section = Section(rawValue: indexPath.section) {
                   switch section {
                   case .main :
                       let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                       return cell
                   }
               } else {
                   return nil
               }
           })
       }
    
//        private func updateSnapshot() {
//            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//            snapshot.appendSections(Section.allCases)
//            snapshot.appendItems(list, toSection: .main)
//            //        snapshot.appendItems(photoList, toSection: .sub)
//            dataSource.apply(snapshot) //reloadData의 역할
//          //  dataSource.applySnapshotUsingReloadData(snapshot)//Realm을 사용할 때 적용할 수 있음
//                //Diff을 안쓰고, reloadData로 동작하고 있음
//        }
    
        private func sectionSnapshot() {
            var snapshot = dataSource.snapshot(for: .main)
            snapshot.append(list)
            dataSource.apply(snapshot, to: .main, animatingDifferences: true)
        }

    private func updateSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
 
}


extension ShelterListViewController {

    func fetchImageSize(completionHandler: @escaping ([CGFloat]) -> Void) {
        let group = DispatchGroup()
        var heightList: [CGFloat] = []
        let cellWidth: CGFloat = (view.bounds.width - 10) / 2
        for item in list {
            let url = URL(string: item.popfile)!
            var imageRatio: Double = 0
            downloadImageAndRetrieveSize(from: url) { image, size in
                guard let size = size else { return }
                imageRatio = (size.width / size.height) * cellWidth
                heightList.append(imageRatio)
                print(imageRatio, cellWidth, "변경됐음??")
            }
        }
        completionHandler(heightList)
        
    }

    private func downloadImageAndRetrieveSize(from url: URL, completion: @escaping (UIImage?, CGSize?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                let size = image.size
                print("킹피셔 됨?")
                completion(image, size)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil, nil)
            }
        }
    }
}
 
