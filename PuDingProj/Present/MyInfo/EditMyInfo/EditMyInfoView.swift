//
//  EditMyInfoView.swift
//  PuDingProj
//
//  Created by cho on 4/26/24.
//

import UIKit
import SnapKit

final class EditMyInfoView: BaseView {
    
    let profileImageView = UIImageView()
    let editImageButton = UIButton()
    let nicknameTextField = LoginTextField(placeHolderText: " 닉네임을 입력해주세요")
    let emailTextField = LoginTextField(placeHolderText: " 이메일을 입력해주세요")
    let phoneNumTextField = LoginTextField(placeHolderText: " 전화번호를 입력해주세요")
    let button: UIButton = {
       let view = UIButton()
        view.setTitle("수정", for: .normal)
        view.backgroundColor = .red
        return view
    }()
    var image = UIImage(systemName: "person")
    

    override func configureViewLayout() {
        self.addSubviews([profileImageView, editImageButton, nicknameTextField, emailTextField, phoneNumTextField, button])
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        editImageButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalTo(profileImageView)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(editImageButton.snp.bottom).offset(16)
        }
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)

        }
        phoneNumTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureAttribute() {
        editImageButton.setTitle("프로필 사진 변경", for: .normal)
        editImageButton.tintColor = .yellow
        editImageButton.backgroundColor = .green
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(systemName: "person")
        phoneNumTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
    }
    
    func updateUI(data: InqueryProfileModel) {
        nicknameTextField.text = data.nick
        emailTextField.text = data.email
        phoneNumTextField.text = data.phoneNum
    }
}
