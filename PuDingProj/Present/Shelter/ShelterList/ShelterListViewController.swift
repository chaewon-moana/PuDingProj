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

class ShelterListViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShelterCollectionViewCell", for: indexPath) as! ShelterCollectionViewCell
        cell.updateUI(item: list[indexPath.item])
        return cell
    }
    
    enum Section: Int, CaseIterable {
        case main
    }

    let mainView = ShelterListView()
    let viewModel = ShelterListViewModel()
    
    var list: [Item] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var itemList = PublishRelay<[Item]>()
    var trigger: () = ()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trigger = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        mainView.collectionView.collectionViewLayout = pinterestLayout
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ShelterCollectionViewCell.self, forCellWithReuseIdentifier: "ShelterCollectionViewCell")
//        itemList
//            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "ShelterCollectionViewCell", cellType: ShelterCollectionViewCell.self)) { (index, item, cell) in
//                cell.updateUI(item: item)
//                cell.layoutIfNeeded()
//            }
//            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func bind() {
        var inputTrigger = BehaviorRelay(value: trigger)
        
        let input = ShelterListViewModel.Input(Trigger: inputTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.itemList
            .subscribe(with: self) { owner, response in
                owner.list = response.body.items.item
                owner.itemList.accept(owner.list)
                print("되긴함", owner.list)
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension ShelterListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 10) / 2
        let url = URL(string: list[indexPath.item].popfile)!
     //   var itemSize = CGSize(width: 0, height: 0)
        var imageRatio: Double = 0
        downloadImageAndRetrieveSize(from: url) { image, size in
            //itemSize = size ?? CGSize(width: 0, height: 0)
            guard let size = size else { return }
            imageRatio = size.width / size.height
            print(imageRatio, cellWidth, "변경됐음??")
        }
        return CGFloat(imageRatio) * cellWidth
    }
    
    private func downloadImageAndRetrieveSize(from url: URL, completion: @escaping (UIImage?, CGSize?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                let size = image.size
                completion(image, size)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil, nil)
            }
        }
    }
    
    
}

//compositional Layout
//extension ShelterListViewController {
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//}
//
//extension ShelterListViewController: MyLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
//                let cellWidth: CGFloat = (view.bounds.width - 4) / 2 // 셀 가로 크기
//                let imageHeight = 150//list[indexPath.item].image.size.width
//                let imageWidth = 100//list[indexPath.item].image.size.width
//                // 이미지 비율
//                let imageRatio = imageHeight/imageWidth
//
//            return CGFloat(imageRatio) * cellWidth
//    }
//}



//    private func fetchPhoto() {
//
//        let url = "https://picsum.photos/v2/list"
//        AF.request(url).validate(statusCode: 200...500).responseDecodable(of: [CellInfo].self) { response in
//            switch response.result {
//            case .success(let value):
//                for item in 0...value.count - 1 {
//                    self.list.append(value[item])
//                }
//                self.sectionSnapshot()
//            case .failure(let failure):
//                print(failure)
//            }
//        }
//    }
    
//    private func cellRegistration() -> UICollectionView.CellRegistration<ShelterCollectionViewCell, Item> {
//        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
//            cell.updateUI(itemIdentifier: itemIdentifier)
//        }
//    }
//    
//    private func configureDataSource() {
//        let cellRegistration = cellRegistration()
//        
//        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            
//            if let section = Section(rawValue: indexPath.section) {
//                switch section {
//                case .main :
//                    let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//                    return cell
//                }
//            } else {
//                return nil
//            }
//        })
//    }
//    
//    private func updateSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//        snapshot.appendSections(Section.allCases)
//        //        snapshot.appendItems(list, toSection: .main)
//        //        snapshot.appendItems(photoList, toSection: .sub)
//        dataSource.apply(snapshot) //reloadData의 역할
//        dataSource.applySnapshotUsingReloadData(snapshot)//Realm을 사용할 때 적용할 수 있음
//            //Diff을 안쓰고, reloadData로 동작하고 있음
//    }
//    
//    private func sectionSnapshot() {
//        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
//        snapshot.append(list)
//        dataSource.apply(snapshot, to: .main)
//   
//    }
//
