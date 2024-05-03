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
            make.centerY.equalTo(profileImageView)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(categoryLabel.snp.bottom)
        }
        registerDate.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(stackView.snp.top)
            make.height.greaterThanOrEqualTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading)
            make.top.equalTo(stackView.snp.top).offset(8)
            make.bottom.equalTo(stackView.snp.bottom)
        }
        //TODO: 이미지를 상단으로 당근처럼 올리기
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
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
        categoryLabel.textColor = .lightGray
        categoryLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.font = .systemFont(ofSize: 15)
        registerDate.font = .systemFont(ofSize: 15)
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
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
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            photoImageView.layer.cornerRadius = 16
        } else {
            photoImageView.isHidden = true
        }
        let imageURL = URL(string: APIKey.baseURL.rawValue + item.creator.profileImage!)
        profileImageView.kf.setImage(with: imageURL)
        categoryLabel.text = item.content1
        nicknameLabel.text = item.creator.nick
        let date = DateManager().calculateTimeDifference(item.createdAt)
        print(item.createdAt, Date(), "여기서 왜 자꾸 에러가 나느뇽")
        registerDate.text = "|  \(date)전"
        titleLabel.text = item.title
        contentLabel.text = item.content
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


