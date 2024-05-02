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
    let contentStackView = UIStackView()
    
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
        let imageURL = URL(string: APIKey.baseURL.rawValue + item.creator.profileImage!)
        profileImageView.kf.setImage(with: imageURL)
        nicknameLabel.text = item.creator.nick
        contentLabel.text = item.content
        dateLabel.text = DateManager().calculateTimeDifference(item.createdAt)
    }
    
    private func configureLayout() {
        contentView.addSubviews([profileImageView, nicknameLabel, contentLabel, dateLabel, deleteButton, contentStackView])
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.height.greaterThanOrEqualTo(24)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.bottom.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
        }
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
    }
    
    private func configureAttribute() {
        deleteButton.isUserInteractionEnabled = true
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        profileImageView.image = UIImage(systemName: "star")
        nicknameLabel.text = "뫄나모나"
        nicknameLabel.font = .systemFont(ofSize: 14)
        contentLabel.text = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfdsafasdfasdfasdfasdfasdfasdfsdfasdfasdf"
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        dateLabel.text = "33333.3333.333.33"
        dateLabel.font = .systemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
