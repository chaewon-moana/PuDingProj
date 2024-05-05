//
//  CommunitiyView.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import SnapKit

final class CommunitiyView: BaseView {

    let tableView = UITableView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func configureViewLayout() {
        self.addSubviews([tableView])
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
