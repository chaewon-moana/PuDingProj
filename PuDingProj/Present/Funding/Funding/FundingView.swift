//
//  FundingView.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import SnapKit

final class FundingView: BaseView {
    //let titleLabel = UILabel()
    let tableView = UITableView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.rowHeight = 170
    }
    
    override func configureViewLayout() {
        self.addSubviews([tableView])
  
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureAttribute() {
    }
}
