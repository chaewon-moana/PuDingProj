//
//  LoginView.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation
import UIKit
import SnapKit

final class LoginView: BaseView {
    let nicknameTextField = LoginTextField(placeHolderText: "닉네임을 입력해주세요")
    let emailTextField = LoginTextField(placeHolderText: "이메일을 입력해주세요")
    let passwordTextField = LoginTextField(placeHolderText: "비밀번호를 입력해주세요")
    let phoneNumTextField = LoginTextField(placeHolderText: "전화번호를 입력해주세요")
    let button: UIButton = {
       let view = UIButton()
        view.setTitle("저장", for: .normal)
        view.backgroundColor = .red
        return view
    }()
    
    override func configureViewLayout() {
        self.addSubviews([nicknameTextField, emailTextField, passwordTextField, phoneNumTextField, button])
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        phoneNumTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        
    }
    
   
}
