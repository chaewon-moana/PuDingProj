//
//  FundingView.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import SnapKit

final class FundingView: BaseView {
    let titleLabel = UILabel()
    let tableView = UITableView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.rowHeight = 170
    }
    
    override func configureViewLayout() {
        self.addSubviews([titleLabel, tableView])
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureAttribute() {
        titleLabel.text = "기부후원펀딩"
        tableView.backgroundColor = .yellow
    }
}
