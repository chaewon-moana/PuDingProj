//
//  CommunitiyView.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import SnapKit

final class CommunitiyView: BaseView {

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
        self.addSubviews([collectionView])
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
