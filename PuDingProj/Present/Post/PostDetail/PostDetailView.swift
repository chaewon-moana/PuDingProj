//
//  PostDetailView.swift
//  PuDingProj
//
//  Created by cho on 4/20/24.
//

import UIKit
import SnapKit

final class PostDetailView: BaseView {
    let profileImageLogo = UIImageView()
    let nicknameLabel = UILabel()
    let titleLabel = UILabel()
    let imageStackView = UIStackView()
    let contentLabel = UILabel()
    let registerDateLabel = UILabel()
    let likeMarkImage = UIImageView()
    let likeCountLabel = UILabel()
    let commentMarkImage = UIImageView()
    let commentCountLabel = UILabel()
    let commentView = UIView()
    let commentTextView = UITextView()
    let commentSendButton = UIButton()
    
    override func configureViewLayout() {
        self.addSubviews([profileImageLogo, nicknameLabel, titleLabel, imageStackView, contentLabel, registerDateLabel, likeMarkImage, likeCountLabel,commentMarkImage, commentCountLabel, commentView])
        commentView.addSubviews([commentTextView, commentSendButton])
        profileImageLogo.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageLogo.snp.trailing).offset(8)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.top.equalTo(profileImageLogo.snp.bottom).offset(12)
        }
        imageStackView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(imageStackView.snp.bottom).offset(8)
        }
        registerDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(4)
        }
        likeMarkImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(likeMarkImage.snp.trailing).offset(4)
        }
        
        commentMarkImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(likeCountLabel.snp.trailing).offset(12)
        }
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(commentMarkImage.snp.trailing).offset(4)
        }
        commentView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.bottom.horizontalEdges.equalTo(self)
        }
        commentTextView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.trailing.equalTo(commentSendButton.snp.leading).inset(8)
            make.height.equalTo(50)
        }
        commentSendButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.bottom.trailing.equalToSuperview().inset(8)
        }
    }
    
    
    func updateUI(item: inqueryPostModel) {
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.title
        contentLabel.text = item.content
        registerDateLabel.text = item.createdAt
    }
    
    override func configureAttribute() {
        commentSendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        commentTextView.backgroundColor = .yellow
        commentTextView.text = "asdfasdfasdfasdfasdfasdfasdfasdf"
        commentView.backgroundColor = .blue
        commentMarkImage.image = UIImage(systemName: "bubble.left")
        commentCountLabel.text = "88"
        commentCountLabel.font = .systemFont(ofSize: 11)
        likeCountLabel.text = "88"
        likeCountLabel.font = .systemFont(ofSize: 11)
        likeMarkImage.image = UIImage(systemName: "heart")
        profileImageLogo.image = UIImage(systemName: "person")
        nicknameLabel.text = "모아나테스트"
        nicknameLabel.font = .systemFont(ofSize: 13)
        titleLabel.text = "타이틀 라벨 테스트"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 15)
        imageStackView.backgroundColor = .red
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentLabel.text = "내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트내용테스트"
        registerDateLabel.font = .systemFont(ofSize: 12)
        registerDateLabel.text = "2888.88.88"
    }
}
