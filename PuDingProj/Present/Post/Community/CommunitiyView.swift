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
    //lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let tableView = UITableView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableView.automaticDimension
       // tableView.rowHeight = 200
    }
    

    
    override func configureViewLayout() {
        self.addSubviews([tableView])
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
