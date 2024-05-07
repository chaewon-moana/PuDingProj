//
//  ShelterListView.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import SnapKit

final class ShelterListView: BaseView {
    let titleLabel = UILabel()
    override func configureViewLayout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureAttribute() {
        titleLabel.text = "Coming Soon!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .gray
    }
}
