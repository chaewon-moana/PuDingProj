//
//  LoginTextField.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit
import TextFieldEffects

class LoginTextField: HoshiTextField {
    init(placeHolderText: String) {
        super.init(frame: .zero)
        placeholderColor = .lightGray
        borderInactiveColor = .lightGray
        borderActiveColor = .systemYellow
        placeholderFontScale = 0.9
        font = .systemFont(ofSize: 15)
        textColor = .darkGray
        placeholder = placeHolderText
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


