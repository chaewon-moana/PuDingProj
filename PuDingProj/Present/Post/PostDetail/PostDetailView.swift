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
    let imageScrollView = UIScrollView()
    let commentStackView = UIStackView()
    let commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
            // guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            let layoutSection: NSCollectionLayoutSection
            //cell
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            //Section
            layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            
            return layoutSection
        }
        
        return layout
    }
    
    override func configureViewLayout() {
        self.addSubviews([scrollView, commentView])
        scrollView.addSubview(backView)
        backView.addSubviews([profileImageLogo, nicknameLabel, titleLabel, contentLabel, registerDateLabel, likeMarkImage,  likeCountLabel,commentMarkImage, commentCountLabel, imageScrollView, commentCollectionView])
        commentView.addSubviews([commentTextView, commentSendButton])
        imageScrollView.addSubview(imageStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(commentView.snp.top).offset(-4)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        profileImageLogo.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.leading.equalToSuperview().offset(8)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageLogo.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().offset(8)
            make.top.equalTo(profileImageLogo.snp.bottom).offset(12)
        }
        imageScrollView.snp.makeConstraints { make in
            make.height.equalTo(120)
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
            make.bottom.equalTo(commentCollectionView.snp.top)
        }
       
        commentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(likeCountLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(backView.snp.bottom)
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

    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.snp.updateConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(commentView.snp.top).offset(-4)
        }
    }
    
    func updateUI(item: inqueryPostModel) {
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.title
        contentLabel.text = item.content
        registerDateLabel.text = item.createdAt
        commentCountLabel.text = "\(item.comments.count)"
        
        if item.files.isEmpty {
            imageStackView.isHidden = true
            //thumbnailImageView.image = UIImage(systemName: "heart")
        } else {
            for image in item.files {
                guard let url = URL(string: APIKey.baseURL.rawValue + image) else {
                    return
                }
                let options: KingfisherOptionsInfo = [
                    .requestModifier(ImageDownloadRequest())
                ]
                let view = UIImageView()
                view.kf.setImage(with: url, options: options)
                view.contentMode = .scaleAspectFit
                view.snp.makeConstraints { make in
                    make.width.equalTo(100)
                }
                imageStackView.addArrangedSubview(view)
            }
            
        }
    }
    
    override func configureAttribute() {
        backView.isUserInteractionEnabled = true
        imageStackView.axis = .horizontal
        commentSendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        commentTextView.backgroundColor = .yellow
        commentTextView.text = "asdfasdfasdfasdfasdfasdfasdfasdf"
        commentView.backgroundColor = .blue
        commentMarkImage.image = UIImage(systemName: "bubble.left")
        
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
