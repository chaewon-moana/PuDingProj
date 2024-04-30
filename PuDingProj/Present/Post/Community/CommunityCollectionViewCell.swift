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
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let registerDate = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let stackView = UIView()
    let imageStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAttribute()
        
    }
    
    private func configureLayout() {
        contentView.addSubviews([categoryLabel, profileImageView, nicknameLabel, registerDate, titleLabel, imageStackView, contentLabel])

        categoryLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        registerDate.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.height.lessThanOrEqualTo(50)
        }
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.lessThanOrEqualTo(40)
        }
        imageStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.height.equalTo(70)
        }
        imageStackView.backgroundColor = .purple
        
    }
    private func configureAttribute() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 16
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
            for idx in item.files {
                guard let url = URL(string: APIKey.baseURL.rawValue + idx) else {
                    return
                }
                let options: KingfisherOptionsInfo = [
                    .requestModifier(ImageDownloadRequest())
                ]
                let view = UIImageView()
                view.snp.makeConstraints { make in
                    make.size.equalTo(70)
                }
                view.kf.setImage(with: url, options: options)
                view.contentMode = .scaleAspectFit
                imageStackView.addArrangedSubview(view)
            }
        } else {
            imageStackView.isHidden = true
        }
        
        let imageURL = URL(string: APIKey.baseURL.rawValue + item.creator.profileImage!)
        profileImageView.kf.setImage(with: imageURL)
        categoryLabel.text = item.content1
        nicknameLabel.text = item.creator.nick
        registerDate.text = "| \(item.createdAt)"
        titleLabel.text = item.title
        contentLabel.text = item.content
        
    }
    
    func setSize(width: CGFloat, item: inqueryPostModel) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = item.content
        label.sizeToFit()
        return label.frame.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//           let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
//           layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//           return layoutAttributes
//       }

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
        return modifiedRequest
    }
}


