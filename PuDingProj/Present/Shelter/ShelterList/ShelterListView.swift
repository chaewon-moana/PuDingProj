//
//  ShelterListView.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import SnapKit

final class ShelterListView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    
    override func configureViewLayout() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttribute() {
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        //item은 group에 대한 사이즈 비율
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
//    func collectionViewLayout() -> UICollectionViewFlowLayout {
//        let layout = UICollectionViewFlowLayout()
//        let itemWidth: CGFloat = (UIScreen.main.bounds.width / 2) - 20
//        let itemHeight: CGFloat = 200
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        return layout
//    }


    

}
