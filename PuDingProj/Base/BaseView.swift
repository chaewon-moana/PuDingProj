//
//  BaseViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewLayout()
        configureAttribute()
      
    }
    
    func configureViewLayout() {
        
    }

    func configureAttribute() {
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
