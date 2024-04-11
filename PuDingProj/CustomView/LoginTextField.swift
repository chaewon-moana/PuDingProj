//
//  LoginTextField.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit

class LoginTextField: UITextField {
    init(placeHolderText: String) {
        super.init(frame: .zero)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        font = .systemFont(ofSize: 14)
        textColor = .gray
        placeholder = placeHolderText
        
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
