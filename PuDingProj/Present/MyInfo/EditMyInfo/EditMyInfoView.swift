//
//  EditMyInfoView.swift
//  PuDingProj
//
//  Created by cho on 4/26/24.
//

import UIKit
import SnapKit
import Kingfisher


final class EditMyInfoView: BaseView {
    
    let profileImageView = UIImageView()
    let editImageButton = UIButton()
    let nicknameTextField = LoginTextField(placeHolderText: " 닉네임을 입력해주세요")

    let phoneNumTextField = LoginTextField(placeHolderText: " 전화번호를 입력해주세요")
    let button: UIButton = {
       let view = UIButton()
        view.setTitle("수정", for: .normal)
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 16
        return view
    }()
    var image = UIImage(systemName: "person")
    

    override func configureViewLayout() {
        self.addSubviews([profileImageView, editImageButton, nicknameTextField, phoneNumTextField, button])
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
     
        phoneNumTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureAttribute() {
        editImageButton.setTitle("프로필 사진 변경", for: .normal)
        editImageButton.titleLabel?.font = .systemFont(ofSize: 14)
        editImageButton.setTitleColor(.lightGray, for: .normal)
        editImageButton.tintColor = .yellow
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "PudingLogo")
        phoneNumTextField.keyboardType = .numberPad
    }
    
    func updateUI(data: InqueryProfileModel) {
        nicknameTextField.text = data.nick
        phoneNumTextField.text = data.phoneNum
        if let profile = data.profileImage {
            guard let url = URL(string: APIKey.baseURL.rawValue + profile) else { return }
                let options: KingfisherOptionsInfo = [
                     .requestModifier(ImageDownloadRequest())
                 ]
            profileImageView.kf.setImage(with: url, options: options)
        } else {
            profileImageView.image = UIImage(named: "PudingLogo")
        }
        
    }
}
