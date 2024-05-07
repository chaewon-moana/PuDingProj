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
import SnapKit

enum Section: CaseIterable {
    case main
}


final class PostDetailViewController: BaseViewController {
    let mainView = PostDetailView()
    let viewModel = PostDetailViewModel()
    var item: inqueryPostModel?
    
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
    
    var list: [WriteCommentModel] = []
    var commentList = PublishRelay<[WriteCommentModel]>()
    
    var commentID: String = ""
    var commentDelete: Void = ()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = item!.comments
        commentList.accept(list)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          view.addGestureRecognizer(tapGesture)
        
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [likeButton, settingButton]
        
        mainView.commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        
        commentList
            .bind(to: mainView.commentTableView.rx.items(cellIdentifier: "CommentTableViewCell", cellType: CommentTableViewCell.self)) { (index, item, cell) in
                print("이거 실행되고 있는데 왜 안됨?")
                cell.updateUI(item: item)
                cell.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        let keyboardHeight = NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .map { notification -> CGFloat in
                if let userInfo = notification.userInfo,
                   let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    return keyboardFrame.height
                }
                return 0
            }
        
        keyboardHeight
                    .subscribe(onNext: { [weak self] height in
                        guard let self = self else { return }
                        self.mainView.commentViewBottomConstraint?.update(offset: -height) // commentView의 하단 제약 조건 업데이트
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded() // 변경된 제약 조건에 따라 레이아웃 업데이트
                        }
                    })
                    .disposed(by: disposeBag)

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // commentView 위치 초기화
        mainView.commentViewBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
                owner.commentList.accept(model.comments)
                owner.mainView.commentTableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.updatePost
            .subscribe(with: self) { owner, model in
                owner.mainView.updateUI(item: model)
                owner.list = model.comments
                owner.commentList.accept(owner.list)
                owner.mainView.commentTableView.reloadData()
            }
            .disposed(by: disposeBag)
        output.commentUpdate
            .subscribe(with: self) { owner, model in
                owner.list.append(model)
                owner.commentList.accept(owner.list)
            }
            .disposed(by: disposeBag)
    }
}
