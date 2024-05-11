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
    
    //let settingButton = UIButton()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let followerLabel = UILabel()
    let followingLabel = UILabel()
    let firstUnderLine = UIView()
    let mypostLabel = UILabel()
    let withdrawButton = UIButton()
    let mypostTableView = UITableView()
    let fundingInfoLabel = UILabel()
    let fundingPriceLabel = UILabel()
    
    override func configureViewLayout() {
        self.addSubviews([profileImageView, nicknameLabel, followerLabel, followingLabel, firstUnderLine, mypostLabel, withdrawButton, mypostTableView, fundingInfoLabel, fundingPriceLabel])
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

        firstUnderLine.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        fundingInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(firstUnderLine.snp.bottom).offset(4)
        }
        fundingPriceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(fundingInfoLabel.snp.bottom).offset(4)
            make.height.equalTo(40)
        }
        withdrawButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        mypostLabel.snp.makeConstraints { make in
            make.top.equalTo(fundingPriceLabel.snp.bottom).offset(16)
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
        fundingPriceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        fundingPriceLabel.layer.cornerRadius = 4
        fundingPriceLabel.layer.borderWidth = 1
        fundingPriceLabel.layer.borderColor = UIColor.lightGray.cgColor
        fundingPriceLabel.textAlignment = .center
        
        let item = MoneyFormatter.shared.string(from: 528000)
        fundingPriceLabel.text = "\(item)원"
        
        firstUnderLine.backgroundColor = .lightGray
        firstUnderLine.layer.borderColor = UIColor.lightGray.cgColor
        firstUnderLine.layer.borderWidth = 1
        fundingInfoLabel.text = "총 후원 금액"
        fundingInfoLabel.font = .systemFont(ofSize: 14)
    }
}
