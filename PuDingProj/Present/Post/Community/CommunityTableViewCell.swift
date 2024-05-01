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

final class CommunityTableViewCell: UITableViewCell {
    
    let categoryLabel = UILabel()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let registerDate = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let stackView = UIStackView()
    //let imageStackView = UIStackView()
    let photoImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureLayout()
        configureAttribute()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        configureLayout()
    }

    private func configureLayout() {
        contentView.addSubviews([categoryLabel, profileImageView, nicknameLabel, registerDate, titleLabel, stackView])
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(photoImageView)
        
        
        categoryLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(30)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        registerDate.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(stackView.snp.top)
            make.height.greaterThanOrEqualTo(24)
        }

        stackView.backgroundColor = .red
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading)
            //make.trailing.equalTo(photoImageView.snp.leading)
            make.top.equalTo(stackView.snp.top).offset(8)
            make.bottom.equalTo(stackView.snp.bottom)
        }
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
           //make.leading.equalTo(contentLabel.snp.leading)
            make.top.equalTo(stackView.snp.top).offset(8)
            make.trailing.equalTo(stackView.snp.trailing) // 필요에 따라 추가
            make.bottom.equalTo(stackView.snp.bottom).offset(-8) // 필요에 따라 조정
        }
    }
    private func configureAttribute() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 16
        photoImageView.backgroundColor = .purple
//        imageStackView.axis = .horizontal
//        imageStackView.distribution = .fill
        categoryLabel.backgroundColor = .red
        categoryLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.backgroundColor = .orange
        nicknameLabel.font = .systemFont(ofSize: 15)
        registerDate.backgroundColor = .yellow
        registerDate.font = .systemFont(ofSize: 15)
        titleLabel.backgroundColor = .yellow
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        contentLabel.backgroundColor = .blue
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 4
    }
    
    func updateUI(item: inqueryPostModel) {
        if !item.files.isEmpty {
            photoImageView.isHidden = false
            guard let url = URL(string: APIKey.baseURL.rawValue + item.files[0]) else {
                return
            }
            let options: KingfisherOptionsInfo = [
                .requestModifier(ImageDownloadRequest())
            ]
            photoImageView.kf.setImage(with: url, options: options)
            photoImageView.contentMode = .scaleAspectFit
        } else {
          //  contentLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            photoImageView.isHidden = true // 이미지가 없을 때
        }
        
        let imageURL = URL(string: APIKey.baseURL.rawValue + item.creator.profileImage!)
        profileImageView.kf.setImage(with: imageURL)
        categoryLabel.text = item.content1
        nicknameLabel.text = item.creator.nick
        registerDate.text = "| \(item.createdAt)"
        titleLabel.text = item.title
        contentLabel.text = item.content
        //layoutIfNeeded()
        
    }
    
    func setSize(item: inqueryPostModel) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = item.content
        label.sizeToFit()
        return label.frame.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
        photoImageView.image = nil
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
        return modifiedRequest
    }
}


