//
//  CommentCollectionViewCell.swift
//  PuDingProj
//
//  Created by cho on 4/22/24.
//

import UIKit
import SnapKit

final class CommentCollectionViewCell: UICollectionViewCell {
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubviews([profileImageView, nicknameLabel, contentLabel, dateLabel])
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentLabel)
        }
    }
    
    private func configureAttribute() {
        profileImageView.image = UIImage(systemName: "star")
        nicknameLabel.text = "뫄나모나"
        nicknameLabel.font = .systemFont(ofSize: 14)
        contentLabel.text = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfdsafasdfasdfasdfasdfasdfasdfsdfasdfasdf"
        contentLabel.font = .systemFont(ofSize: 13)
        dateLabel.text = "33333.3333.333.33"
        dateLabel.font = .systemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.width = ceil(size.width)
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
