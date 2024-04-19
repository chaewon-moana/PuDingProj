//
//  MyInfoView.swift
//  PuDingProj
//
//  Created by cho on 4/13/24.
//

import UIKit
import SnapKit

final class MyInfoView: BaseView {
    
    let settingLabel = UILabel()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let followerLabel = UILabel()
    let followingLabel = UILabel()
    let firstUnderLine = UIView()
    let donationView = UIView()
    let donationLabel = UILabel()
    let donationPriceLabel = UILabel()
    let supportView = UIView()
    let supportLabel = UILabel()
    let supportCountLabel = UILabel()
    let mypostLabel = UILabel()
   // let collectionView = UICollectionView()
    
    
    override func configureViewLayout() {
        self.addSubviews([profileImageView, nicknameLabel, followerLabel, followingLabel, settingLabel, firstUnderLine, donationView, supportView, mypostLabel])
        donationView.addSubviews([donationLabel, donationPriceLabel])
        supportView.addSubviews([supportLabel, supportCountLabel])
        
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
        settingLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        firstUnderLine.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        donationView.snp.makeConstraints { make in
            make.top.equalTo(firstUnderLine.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        donationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
        donationPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(donationLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        supportView.snp.makeConstraints { make in
            make.top.equalTo(firstUnderLine.snp.bottom).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        supportLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
        supportCountLabel.snp.makeConstraints { make in
            make.top.equalTo(donationLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
       
    }
    override func configureAttribute() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1
        
        nicknameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        followerLabel.font = .systemFont(ofSize: 13)
        followingLabel.font = .systemFont(ofSize: 13)
        settingLabel.font = .systemFont(ofSize: 13)
        settingLabel.textColor = .lightGray
        firstUnderLine.backgroundColor = .lightGray
        firstUnderLine.layer.borderColor = UIColor.lightGray.cgColor
        firstUnderLine.layer.borderWidth = 1
        donationView.backgroundColor = .blue
        donationLabel.textAlignment = .center
        donationPriceLabel.textAlignment = .center
        supportView.backgroundColor = .purple
        supportLabel.textAlignment = .center
        supportCountLabel.textAlignment = .center
        
        //MARK: dummy data
        profileImageView.image = UIImage(systemName: "star")
        nicknameLabel.text = "닉네임 없음"
        followerLabel.text = "팔로워 8888"
        followingLabel.text = "팔로잉 8888"
        settingLabel.text = "설정"
        donationLabel.text = "후원 금액"
        donationPriceLabel.text = "₩ 88,888,888"
        supportLabel.text = "물품 후원"
        supportCountLabel.text = "88 건"
    }
}