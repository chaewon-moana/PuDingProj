//
//  PostDetailViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostDetailViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let postItem: Observable<inqueryPostModel>
        let backButtonTapped: Observable<Void>
        let commentSendButtonTapped: Observable<Void>
        let commentText: Observable<String>
        let settingButtonTapped: Observable<Void>
        let cellDeleataButtonTapped: Observable<Void>
        let deleteComment: Observable<String>
        let likeButtonTapped: Observable<Void>
        let likeValue: Observable<Bool>
        let deleteTapped: Observable<Void>
    }
    
    struct Output {
        let postResult: Observable<inqueryPostModel>
        let updatePost: Observable<inqueryPostModel>
        let backButtonTapped: Driver<Void>
        let commentUpdate: Observable<WriteCommentModel>
        let showDeleteAlert: Driver<Void>
        let moveToPost: Driver<Void>
        
    }
    
    struct CommentOnPost {
        let comment: String
    }
    
    func transform(input: Input) -> Output {
        let updatePostModel = PublishRelay<inqueryPostModel>()
        let commentObservable = Observable.combineLatest(input.commentText, input.postItem)
        let comment = Observable.combineLatest(input.postItem, input.deleteComment)
        let likeObservable = Observable.combineLatest(input.postItem, input.likeButtonTapped, input.likeValue)
        let commentUpdate = PublishRelay<WriteCommentModel>()
        let postID = BehaviorRelay<String>(value: "")
        let showDeleteAlert = PublishRelay<Void>()
        let moveToPost = PublishRelay<Void>()
        
        
        input.commentSendButtonTapped
            .withLatestFrom(commentObservable)
            .flatMap { value, post in
                print("버튼 눌림")
                postID.accept(post.post_id)
                let item = writeCommentQuery(content: value)
                return NetworkManager.requestNetwork(router: .comment(.writeComment(parameter: item, id: post.post_id)), modelType: WriteCommentModel.self)
            }
            .subscribe { model in
                print(model, "댓글달기 성공")
                commentUpdate.accept(model)
            } onError: { error in
                print("댓글달기 실패")
            }
            .disposed(by: disposeBag)
        
        input.deleteTapped
            .withLatestFrom(input.postItem)
            .map { post in
                NetworkManager.requestDeletePost(router: .post(.deletePost(id: post.post_id)))
            }
            .subscribe { _ in
                print("삭제 성공")
                moveToPost.accept(())
            } onError: { error in
                print(error, "삭제 실패")
            }
            .disposed(by: disposeBag)
        
        input.settingButtonTapped
            .subscribe { _ in
                showDeleteAlert.accept(())
            }
            .disposed(by: disposeBag)


        likeObservable
            .flatMap { post, value, state  in
                let item = LikeQuery(like_status: state)
                let model = input.postItem
                print(post.post_id, "이게 조회가 안된다고?")
                return NetworkManager.requestNetwork(router: .like(.like(query: item, id: post.post_id)), modelType: LikeModel.self)
            }
            .subscribe { value in
                print("좋아여!", value)
            } onError: { error in
                print("좋아여 에러남여!")
            }
            .disposed(by: disposeBag)

//        input.commentSendButtonTapped
//            .withLatestFrom(input.commentText)
//            .flatMap { value in
//                print("버튼 눌림")
//                let item = writeCommentQuery(content: value)
//                return NetworkManager.requestNetwork(router: .comment(.writeComment(parameter: item, id: "662203e7438b876b25f7d3c5")), modelType: WriteCommentModel.self)
//            }
//            .subscribe { model in
//                print(model, "댓글달기 성공")
//            } onError: { error in
//                print("댓글달기 실패")
//            }
//            .disposed(by: disposeBag)
        
        return Output(postResult: input.postItem,
                      updatePost: updatePostModel.asObservable(),
                      backButtonTapped: input.backButtonTapped.asDriver(onErrorJustReturn: ()),
                      commentUpdate: commentUpdate.asObservable(), 
                      showDeleteAlert: showDeleteAlert.asDriver(onErrorJustReturn: ()), 
                      moveToPost: moveToPost.asDriver(onErrorJustReturn: ()))
    }
}


