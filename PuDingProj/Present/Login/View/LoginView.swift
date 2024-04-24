//
//  JoinView.swift
//  PuDingProj
//
//  Created by cho on 4/15/24.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    let emailTextField = LoginTextField(placeHolderText: " 이메일 형식의 아이디를 입력해주세요")
    let passwordTextField = LoginTextField(placeHolderText: " 비밀번호를 입력해주세요")
    let checkBox = UIButton()
    let checkBoxLabel = UILabel()
    let loginButton = UIButton()
    let joinButton = UIButton()
    
    override func configureViewLayout() {
        self.addSubviews([emailTextField, passwordTextField, checkBox, checkBoxLabel, loginButton, joinButton])
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        checkBox.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.leading.equalTo(passwordTextField.snp.leading).offset(8)
        }
        checkBoxLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBox.snp.trailing).offset(8)
            make.centerY.equalTo(checkBox)
        }
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.top.equalTo(checkBoxLabel.snp.bottom).offset(50)
        }
        joinButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.top.equalTo(loginButton.snp.bottom).offset(12)
        }
    }

    override func configureAttribute() {
        checkBox.tintColor = UserDefault.saveEmail.isEmpty ? .gray : .blue
        checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        checkBoxLabel.text = "아이디 저장"
        checkBoxLabel.font = .systemFont(ofSize: 13)
        loginButton.backgroundColor = .blue
        loginButton.setTitle("로그인", for: .normal)
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.setTitleColor(.black, for: .normal)
        emailTextField.keyboardType = .emailAddress
        emailTextField.text = UserDefault.saveEmail
    }
   
}
