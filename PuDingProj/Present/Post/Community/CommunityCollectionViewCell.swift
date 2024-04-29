//
//  CommunityCollectionViewCell.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class CommunityCollectionViewCell: UICollectionViewCell {
    
    let categoryLabel = UILabel()
    let nicknameLabel = UILabel()
    let registerDate = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let stackView = UIView()
    let thumbnailImageView = UIImageView()
    let imageStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAttribute()
        
    }
    
    private func configureLayout() {
        contentView.addSubviews([categoryLabel, nicknameLabel, registerDate, titleLabel, imageStackView])
        imageStackView.addArrangedSubview(contentLabel)

        categoryLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        registerDate.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        imageStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        contentLabel.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(12)
//            make.top.equalTo(titleLabel.snp.bottom).offset(8)
//            make.bottom.equalToSuperview().inset(8)
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }
    }
    private func configureAttribute() {
        thumbnailImageView.image = UIImage(systemName: "star")
        thumbnailImageView.contentMode = .scaleAspectFit
        imageStackView.backgroundColor = .purple
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fill
        categoryLabel.backgroundColor = .red
        categoryLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.backgroundColor = .orange
        nicknameLabel.font = .systemFont(ofSize: 15)
        registerDate.backgroundColor = .yellow
        registerDate.font = .systemFont(ofSize: 15)
        titleLabel.backgroundColor = .green
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentLabel.backgroundColor = .blue
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
    }
    
    func updateUI(item: inqueryPostModel) {
        if !item.files.isEmpty {
            guard let url = URL(string: APIKey.baseURL.rawValue + item.files[0]) else {
                  return
              }
            let options: KingfisherOptionsInfo = [
                 .requestModifier(ImageDownloadRequest())
             ]
            thumbnailImageView.kf.setImage(with: url, options: options)
            imageStackView.addArrangedSubview(thumbnailImageView)
        } else {
           //files이 비어있을 떄 예외처리
        }
        categoryLabel.text = item.post_id
        nicknameLabel.text = item.content1
        registerDate.text = "| \(item.createdAt)"
        titleLabel.text = item.title
        contentLabel.text = item.content
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
           layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
           return layoutAttributes
       }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageDownloadRequest: ImageDownloadRequestModifier {
    func modified(for request: URLRequest) -> URLRequest? {
        var modifiedRequest = request
        modifiedRequest.addValue(UserDefault.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        modifiedRequest.addValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
        modifiedRequest.addValue(HTTPHeader.json.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        // 필요한 경우 다른 헤더도 추가 가능
        return modifiedRequest
    }
}


