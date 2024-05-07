//
//  CommentCollectionViewCell.swift
//  PuDingProj
//
//  Created by cho on 4/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommentTableViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let deleteButton = UIButton()
    let tmpUIView = UILabel()
    
    let buttonTap = PublishSubject<Void>()

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        configureLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAttribute()
        
        deleteButton.rx.tap
            .subscribe(with: self) { owner, value in
                print("cell에서의 동작")
                owner.buttonTap.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    func updateUI(item: WriteCommentModel) {
        if let profile = item.creator.profileImage {
            let imageURL = URL(string: APIKey.baseURL.rawValue + profile)
            profileImageView.kf.setImage(with: imageURL)
        } else {
            profileImageView.image = UIImage(named: "PudingLogo")
        }
        nicknameLabel.text = item.creator.nick
        contentLabel.text = item.content
        contentLabel.numberOfLines = 0
        dateLabel.text = DateManager().calculateTimeDifference(item.createdAt)
        configureLayout()
    }
    
    private func configureLayout() {
        contentView.addSubviews([profileImageView, nicknameLabel, contentLabel, dateLabel, deleteButton, tmpUIView])
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.height.greaterThanOrEqualTo(20)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            //make.bottom.equalTo(dateLabel.snp.top)
            make.height.greaterThanOrEqualTo(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
            make.height.equalTo(20)
        }
        tmpUIView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(dateLabel.snp.bottom)
            //make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(20)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configureAttribute() {
        tmpUIView.text = ""
        deleteButton.isUserInteractionEnabled = true
        deleteButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        deleteButton.tintColor = .gray
        profileImageView.image = UIImage(systemName: "star")
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        nicknameLabel.text = "뫄나모나"
        nicknameLabel.font = .systemFont(ofSize: 14)
        contentLabel.text = "asdfasdfaf"
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0

        dateLabel.text = "33333.3333.333.33"
        dateLabel.font = .systemFont(ofSize: 12)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nicknameLabel.text = nil
        contentLabel.text = nil
        dateLabel.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
