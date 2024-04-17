//
//  CommunitiyView.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import SnapKit

final class CommunitiyView: BaseView {
    
    let searchTextField = UITextField()
    let alertButton = UIButton()
    let filterView = UIView() //collectionView로 만들기
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = UIScreen.main.bounds.width - 20
        let itemHeight: CGFloat = 150
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }
    
    override func configureViewLayout() {
        self.addSubviews([collectionView, searchTextField, alertButton])
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(searchTextField.snp.bottom)
        }
        alertButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(alertButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }
        
    }
    
    override func configureAttribute() {
        searchTextField.placeholder = "검색어를 입력해주세요"
        alertButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
    }
}

    
    //TODO: Diffable로 처리하기
    //    var dataSource: UICollectionViewDiffableDataSource<String, RegisterPost>!
    //
    //

    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        configureDataSource()
    //        itemSnapShot()
    //        collectonView.backgroundColor = .yellow
    //
    //    }
    //    private func cellRegistration() -> UICollectionView.CellRegistration<CommunityCollectionViewCell, RegisterPost> {
    //        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
    //            cell.updateUI(item: itemIdentifier)
    //        }
    //    }
    //
    //    private func itemSnapShot() {
    //        var snapshot = NSDiffableDataSourceSectionSnapshot<RegisterPost>()
    //        snapshot.append(list)
    //        dataSource.apply(snapshot, to: "123")
    //    }
    //    private func configureDataSource() {
    //        let cellRegistration = cellRegistration()
    //
    //        dataSource = UICollectionViewDiffableDataSource(collectionView: collectonView, cellProvider: { collectionView, indexPath, itemIdentifier in
    //            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
    //            cell.backgroundColor = .green
    //            return cell
    //        })
    //    }
    //
    //    private func updateSnapShot() {
    //        var snapshot = NSDiffableDataSourceSnapshot<String, RegisterPost>()
    //        dataSource.apply(snapshot)
    //    }
    //
    
    //
    //    private func createLayout() -> UICollectionViewLayout {
    //        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
    //
    //            let layoutSection: NSCollectionLayoutSection
    //            //cell
    //            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    //            let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //            //group
    //            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
    //            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    //
    //            //Section
    //            layoutSection = NSCollectionLayoutSection(group: group)
    //            layoutSection.interGroupSpacing = 5
    //
    //            return layoutSection
    //        }
    //
    //        return layout
    //    }
    

