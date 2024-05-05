//
//  SponsorView.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SponsorView: BaseView {
    
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let attainmentLabel = UILabel()
    let priceLabel = UILabel()
    let contentView = UILabel()
    let sponsorButton = UIButton()
    
    override func configureViewLayout() {
        self.addSubviews([productImageView, titleLabel, attainmentLabel, priceLabel, contentView, sponsorButton])
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(300)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(productImageView.snp.bottom).offset(20)
        }
        attainmentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(self.safeAreaInsets).offset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(attainmentLabel.snp.trailing).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(attainmentLabel.snp.bottom).offset(20)
        }
        sponsorButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-40)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func configureAttribute() {
        titleLabel.numberOfLines = 0
        contentView.numberOfLines = 0
        sponsorButton.setTitle("후원하기", for: .normal)
        sponsorButton.setTitleColor(.black, for: .normal)
        sponsorButton.backgroundColor = .systemYellow
        sponsorButton.clipsToBounds = true
        sponsorButton.layer.cornerRadius = 8
    }
    
    func updateUI(item: inqueryFundingModel) {
        if !item.files.isEmpty {
            productImageView.isHidden = false
            guard let url = URL(string: APIKey.baseURL.rawValue + item.files[0]) else {
                return
            }
            let options: KingfisherOptionsInfo = [
                .requestModifier(ImageDownloadRequest())
            ]
            productImageView.kf.setImage(with: url, options: options)
            productImageView.contentMode = .scaleAspectFill
            productImageView.clipsToBounds = true
            productImageView.layer.cornerRadius = 16
        } else {
            productImageView.image = UIImage(named: "PudingLogo")
        }
        let imageURL = URL(string: APIKey.baseURL.rawValue + item.creator.profileImage!)
        
        //TODO: 오늘 날짜랑 비교해서 며칠 남았는지 처리
        guard let date = item.content3 else { return }
     //   dueDateLabel.text = "\(date)일 남음"
      //  hostShelterLabel.text = "| \(item.content4)"
        titleLabel.text = item.title
        attainmentLabel.text = "달성!!!"
        guard let price = item.content1 else { return }
        priceLabel.text = "\(price)원"
        contentView.text = "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용"
    }
}
