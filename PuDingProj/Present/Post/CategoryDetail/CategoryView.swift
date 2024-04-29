//
//  CategoryView.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import SnapKit

final class CategoryView: BaseView {
    let descriptionLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func configureAttribute() {
        descriptionLabel.text = "카테고리 영역을 설정해주세요"
        descriptionLabel.font = .systemFont(ofSize: 14)
    }
    
    override func configureViewLayout() {
        self.addSubviews([descriptionLabel, collectionView])
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = UIScreen.main.bounds.width - 20
        let itemHeight: CGFloat = 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }
}
