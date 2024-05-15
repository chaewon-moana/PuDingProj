//
//  ShelterListView.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import SnapKit

final class ShelterListView: BaseView {
    let button = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func configureViewLayout() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttribute() {
    }
    
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = (UIScreen.main.bounds.width / 2) - 20
        let itemHeight: CGFloat = 100
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }


    

}
