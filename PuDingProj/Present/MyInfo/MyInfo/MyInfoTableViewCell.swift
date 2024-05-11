//
//  MyInfoTableViewCell.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import UIKit
import SnapKit

final class MyInfoTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let commentImageView = UIImageView()
    let commentCountLabel = UILabel()
    let postImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureAttribute()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    func updateUI(item: RegisterPostModel) {
        contentLabel.snp.removeConstraints()
        postImageView.snp.removeConstraints()
        titleLabel.text = item.title
        contentLabel.text = item.content
        let date = item.createdAt
        let result = DateManager.shared.processData(date: date)
        dateLabel.text = result
        commentCountLabel.text = "\(item.comments!.count)"
        if let profile = item.files?.first {
            let imageURL = URL(string: APIKey.baseURL.rawValue + profile)
            postImageView.kf.setImage(with: imageURL)
            postImageView.contentMode = .scaleAspectFit 
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.trailing.equalTo(self.snp.trailing).inset(8)
                make.leading.equalTo(postImageView.snp.trailing).offset(4)
            }
            postImageView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.leading.equalTo(self.safeAreaLayoutGuide).inset(8)
                make.size.equalTo(72)
            }
        } else {
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            }
        }
    }
    
    private func configureView() {
        contentView.addSubviews([titleLabel, contentLabel, dateLabel, commentImageView, commentCountLabel, postImageView])
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(commentImageView.snp.leading).inset(12)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.size.equalTo(72)
            
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        commentImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(commentCountLabel.snp.leading).offset(-4)
        }
        commentCountLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configureAttribute() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.numberOfLines = 0
        contentLabel.numberOfLines = 4
        contentLabel.font = .systemFont(ofSize: 13)
        commentImageView.image = UIImage(systemName: "bubble")
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        commentCountLabel.font = .systemFont(ofSize: 12)
        commentCountLabel.textColor = .gray
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 8
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
        postImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
