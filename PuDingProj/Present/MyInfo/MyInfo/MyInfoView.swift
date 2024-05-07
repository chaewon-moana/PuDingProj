//
//  MyInfoView.swift
//  PuDingProj
//
//  Created by cho on 4/13/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MyInfoView: BaseView {
    
    let settingButton = UIButton()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let followerLabel = UILabel()
    let followingLabel = UILabel()
    let firstUnderLine = UIView()
    let mypostLabel = UILabel()
    let withdrawButton = UIButton()
    let mypostTableView = UITableView()
    
    override func configureViewLayout() {
        self.addSubviews([profileImageView, nicknameLabel, followerLabel, followingLabel, settingButton, firstUnderLine, mypostLabel, withdrawButton, mypostTableView])
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(profileImageView).offset(4)
        }
        followerLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
        }
        followingLabel.snp.makeConstraints { make in
            make.leading.equalTo(followerLabel.snp.trailing).offset(4)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
        }
        settingButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        firstUnderLine.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        withdrawButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        mypostLabel.snp.makeConstraints { make in
            make.top.equalTo(firstUnderLine.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
        }
        mypostTableView.snp.makeConstraints { make in
            make.top.equalTo(mypostLabel.snp.bottom)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
    func updateUI(item: InqueryProfileModel) {
        nicknameLabel.text = item.nick
        followerLabel.text = item.email
        if let profile = item.profileImage {
            guard let url = URL(string: APIKey.baseURL.rawValue + profile) else { return }
                let options: KingfisherOptionsInfo = [
                     .requestModifier(ImageDownloadRequest())
                 ]
            profileImageView.kf.setImage(with: url, options: options)
        } else {
            profileImageView.image = UIImage(named: "PudingLogo")
        }
       
        
    }
    
    
    override func configureAttribute() {
        mypostLabel.text = "MY POST"
        withdrawButton.setTitle("탈퇴", for: .normal)
        withdrawButton.titleLabel?.font = .systemFont(ofSize: 12)
        withdrawButton.setTitleColor(.gray, for: .normal)
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1
        profileImageView.clipsToBounds = true
        
        nicknameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        followerLabel.font = .systemFont(ofSize: 13)
        followingLabel.font = .systemFont(ofSize: 13)
        settingButton.setTitleColor(.black, for: .normal)
        settingButton.setTitle("수정", for: .normal)
        firstUnderLine.backgroundColor = .lightGray
        firstUnderLine.layer.borderColor = UIColor.lightGray.cgColor
        firstUnderLine.layer.borderWidth = 1
//        donationView.backgroundColor = .blue
//        donationLabel.textAlignment = .center
//        donationPriceLabel.textAlignment = .center
//        supportView.backgroundColor = .purple
//        supportLabel.textAlignment = .center
//        supportCountLabel.textAlignment = .center
        
        //MARK: dummy data
        profileImageView.image = UIImage(named: "PudingLogo")
        nicknameLabel.text = "닉네임 없음"
        followerLabel.text = "팔로워 8888"
        followingLabel.text = ""
//        donationLabel.text = "후원 금액"
//        donationPriceLabel.text = "₩ 88,888,888"
//        supportLabel.text = "물품 후원"
//        supportCountLabel.text = "88 건"
    }
}
