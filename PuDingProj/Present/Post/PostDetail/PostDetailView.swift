//
//  PostDetailView.swift
//  PuDingProj
//
//  Created by cho on 4/20/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PostDetailView: BaseView {
    let scrollView = UIScrollView()
    let backView = UIView()
    let profileImageLogo = UIImageView()
    let nicknameLabel = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let registerDateLabel = UILabel()
    let likeMarkImage = UIImageView()
    let likeCountLabel = UILabel()
    let commentMarkImage = UIImageView()
    let commentCountLabel = UILabel()
    let commentView = UIView()
    let commentTextView = UITextView()
    let commentSendButton = UIButton()
    
    let imageScrollView = UIScrollView()
    let imageStackView = UIStackView()
    
    let commentTableView = UITableView(frame: .zero)
    let commentTextPlaceHolder = UILabel()
    var commentViewBottomConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commentTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
        commentTableView.estimatedRowHeight = 80
        commentTextView.delegate = self
    }
        
    func updateUI(item: inqueryPostModel) {
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.title
        contentLabel.text = item.content
        let date = DateManager().calculateTimeDifference(item.createdAt)
        registerDateLabel.text = "\(date)전"
        commentCountLabel.text = "\(item.comments.count)"
        likeCountLabel.text = "\(item.likes.count)"
        if let profile = item.creator.profileImage {
            let imageURL = URL(string: APIKey.baseURL.rawValue + profile)
            profileImageLogo.kf.setImage(with: imageURL)
        } else {
            profileImageLogo.image = UIImage(named: "PudingLogo")
        }

        
        if item.files.isEmpty {
            imageStackView.isHidden = true
            imageScrollView.snp.makeConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            imageStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            for image in item.files {
                guard let url = URL(string: APIKey.baseURL.rawValue + image) else {
                    return
                }
                let options: KingfisherOptionsInfo = [
                    .requestModifier(ImageDownloadRequest())
                ]
                let view = UIImageView()
                view.kf.setImage(with: url, options: options)
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
                view.layer.cornerRadius = 20

                view.snp.makeConstraints { make in
                    make.width.equalTo(140)
                }
                imageStackView.addArrangedSubview(view)
            }
            
        }
    }
    
    override func configureViewLayout() {
        self.addSubviews([scrollView, commentView])
        scrollView.addSubview(backView)
        backView.addSubviews([profileImageLogo, nicknameLabel, titleLabel, contentLabel, registerDateLabel, likeMarkImage,  likeCountLabel,commentMarkImage, commentCountLabel, imageScrollView, commentTableView])
        commentView.addSubviews([commentTextView, commentSendButton, commentTextPlaceHolder])
        imageScrollView.addSubview(imageStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(commentView.snp.top).offset(-4)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(800)
        }
        profileImageLogo.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.top.leading.equalToSuperview()
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageLogo.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageLogo)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().offset(8)
            make.top.equalTo(profileImageLogo.snp.bottom).offset(12)
        }
        imageScrollView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(contentLabel.snp.top).offset(8)
        }
        imageStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(imageStackView.snp.bottom).offset(8)
            make.bottom.equalTo(registerDateLabel.snp.top).offset(-4)
        }
        registerDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(4)
        }
        likeMarkImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
        }
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(likeMarkImage.snp.trailing).offset(4)
            //make.bottom.equalTo(commentTableView.snp.top)
        }
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(likeMarkImage.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            //make.bottom.equalTo(backView.snp.bottom)
            make.height.equalTo(300)
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
            make.height.equalTo(60)
            make.bottom.horizontalEdges.equalTo(self)
            self.commentViewBottomConstraint = make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).constraint
        }
        commentTextView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.trailing.equalTo(commentSendButton.snp.leading).inset(10)
            make.height.greaterThanOrEqualTo(30)
        }
        commentSendButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.bottom.trailing.equalToSuperview().inset(8)
        }
        commentTextPlaceHolder.snp.makeConstraints { make in
            make.top.leading.equalTo(commentTextView).offset(8)
        }
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.snp.updateConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(commentView.snp.top).offset(-4)
        }
    }
    
    override func configureAttribute() {
        commentTextPlaceHolder.text = "댓글을 입력해주세요"
        scrollView.isScrollEnabled = true
        backView.isUserInteractionEnabled = true
        imageStackView.axis = .horizontal
        imageStackView.spacing = 10
        commentSendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        commentSendButton.tintColor = .systemYellow
        commentMarkImage.image = UIImage(systemName: "bubble.left")
        
        commentCountLabel.font = .systemFont(ofSize: 11)
        likeCountLabel.text = "88"
        likeCountLabel.font = .systemFont(ofSize: 11)
        likeMarkImage.image = UIImage(systemName: "heart")
        profileImageLogo.image = UIImage(systemName: "person")
        profileImageLogo.clipsToBounds = true
        profileImageLogo.layer.cornerRadius = 14
        nicknameLabel.text = "모아나테스트"
        nicknameLabel.font = .systemFont(ofSize: 13)
        titleLabel.text = "타이틀 라벨 테스트"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 15)
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentLabel.text = "내용테스트"
        registerDateLabel.font = .systemFont(ofSize: 12)
        registerDateLabel.text = "2888.88.88"
        
        commentTextView.autocorrectionType = .no
      
        
    }
}
extension PostDetailView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == commentTextView {
            commentTextPlaceHolder.isHidden = !commentTextView.text.isEmpty
        }
    }
}
