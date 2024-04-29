//
//  PostDetailViewController.swift
//  PuDingProj
//
//  Created by cho on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

enum Section: CaseIterable {
    case main
}


final class PostDetailViewController: BaseViewController {
    let mainView = PostDetailView()
    let viewModel = PostDetailViewModel()
    var item: inqueryPostModel?
    var dataSource: UICollectionViewDiffableDataSource<Section, WriteCommentModel>!
    lazy var backButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: nil)
    return view
    }()
    lazy var settingButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
        return view
    }()
    lazy var likeButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: nil)
        return view
    }()
    
    var list: [WriteCommentModel] = [WriteCommentModel(comment_id: "asdf", content: "asdfasdf", createdAt: "asdfasdfasdf", creator: CreatorInfo(user_id: "ddd", nick: "sdfsdfsd", profileImage: nil))]
    
    var commentID: String = ""
    var commentDelete: Void = ()
    
    override func loadView() {
        view = mainView
    }
    
    private func cellRegistration() {
        let cellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, WriteCommentModel> { (cell, indexPath, model) in
            let item = model.creator
            cell.nicknameLabel.text = model.creator.nick
//            guard let url = URL(string: APIKey.baseURL.rawValue + item.profileImage!) else { return }
//                let options: KingfisherOptionsInfo = [
//                     .requestModifier(ImageDownloadRequest())
//                 ]
//            cell.profileImageView.kf.setImage(with: url, options: options)
            cell.profileImageView.image = UIImage(systemName: "person")
            cell.contentLabel.text = model.content
            cell.dateLabel.text = model.createdAt
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, WriteCommentModel>(collectionView: mainView.commentCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            cell.deleteButton.rx.tap
                .subscribe(with: self) { owner, _ in
                    print("cell에 deleteButtonTap함")
                    //TODO: 삭제했을 때, 다시 받아오는 작업 필요함 - 각 Post
                    NetworkManager.requestDeleteComment(postID: owner.item!.post_id , commentID: itemIdentifier.comment_id)
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mainView.commentCollectionView.delegate = self
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [likeButton, settingButton]
        
        cellRegistration()
        updateSnapShot()
        
    }
    
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WriteCommentModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot) //reloadData의 역할
        dataSource.applySnapshotUsingReloadData(snapshot)//Realm을 사용할 때 적용할 수 있음
    }
    
    override func bind() {
        let commentID = Observable.just(commentID)
        let commentTapped = Observable.just(commentDelete)
        let like = item?.likes.contains(UserDefault.userID) ?? false
        let likeObservable = Observable.just(like)
        
        let input = PostDetailViewModel.Input(postItem: Observable.of(item!),
                                              backButtonTapped: backButton.rx.tap.asObservable(),
                                              commentSendButtonTapped: mainView.commentSendButton.rx.tap.asObservable(),
                                              commentText: mainView.commentTextView.rx.text.orEmpty.asObservable(),
                                              settingButtonTapped: settingButton.rx.tap.asObservable(),
                                              cellDeleataButtonTapped: commentTapped,
                                              deleteComment: commentID, likeButtonTapped: likeButton.rx.tap.asObservable(),
                                              likeValue: likeObservable
        )
        
        let output = viewModel.transform(input: input)
        
        output.postResult
            .subscribe(with: self) { owner, model in
                owner.mainView.updateUI(item: model)
                owner.list = model.comments
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped
            .drive(with: self) { owner, _ in
//                if let tabBarController = owner.navigationController?.tabBarController {
//                    tabBarController.selectedIndex = 0
//                    owner.navigationController?.popViewController(animated: true)
//                }
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.updatePost
            .subscribe(with: self) { owner, model in
                owner.mainView.updateUI(item: model)
                owner.list = model.comments
            }
            .disposed(by: disposeBag)
        
    }
}
