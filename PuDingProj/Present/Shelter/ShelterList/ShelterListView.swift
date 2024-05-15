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
    
    override func configureViewLayout() {
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureAttribute() {
        button.setTitle("호출!", for: .normal)
        button.setTitleColor(.black, for: .normal)
    }
}
