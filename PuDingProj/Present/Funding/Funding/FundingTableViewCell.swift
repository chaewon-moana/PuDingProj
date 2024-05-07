//
//  FundingTableViewCell.swift
//  PuDingProj
//
//  Created by cho on 5/1/24.
//

import UIKit
import SnapKit
import Kingfisher

final class FundingTableViewCell: UITableViewCell {
    
    let productImageView = UIImageView()
    let dueDateLabel = UILabel()
    let hostShelterLabel = UILabel()
    let productNameLabel = UILabel()
   // let gaugeBarView = UIView()
    let attainmentLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubviews([productImageView, dueDateLabel, hostShelterLabel, productNameLabel, attainmentLabel, priceLabel])
        productImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
            make.top.equalTo(productImageView.snp.top)
        }
        hostShelterLabel.snp.makeConstraints { make in
            make.leading.equalTo(dueDateLabel.snp.trailing).offset(4)
            make.top.equalTo(productImageView.snp.top)
        }
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(12)
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        attainmentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-16)
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(attainmentLabel.snp.trailing).offset(8)
            make.centerY.equalTo(attainmentLabel)
        }
    }
    
    private func configureAttribute() {
        //MARK: Dummy Date
        dueDateLabel.text = "3일 남음"
        dueDateLabel.font = .systemFont(ofSize: 14)
        hostShelterLabel.text = " | 새싹보호소"
        hostShelterLabel.font = .systemFont(ofSize: 14)
        productImageView.image = UIImage(systemName: "star")
        productNameLabel.text = "더마독 가수분해 단백질 강아지 애견 연어 오리 건강사료, 피부/털, 3kg, 1개"
        productNameLabel.numberOfLines = 2
        attainmentLabel.text = "8888% 달성"
        attainmentLabel.font = .systemFont(ofSize: 15)
        priceLabel.text = "888,888원"
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
        
        //TODO: 오늘 날짜랑 비교해서 며칠 남았는지 처리
        guard let date = item.content3 else { return }
        dueDateLabel.text = "\(date)일 남음"
        guard let shelter = item.content4 else { return }
        hostShelterLabel.text = "| \(shelter)"
        productNameLabel.text = item.title
        attainmentLabel.text = "목표금액"
        guard let price = item.content1 else { return }
        let intPrice = Int(price)
        guard let count = item.content2 else { return }
        let intCount = Int(count)
        let totalPrice = Int((intPrice ?? 0) * (intCount ?? 0))
        let result = MoneyFormatter.shared.string(from: totalPrice as NSNumber)
        priceLabel.text = "\(result)원"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
