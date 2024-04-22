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
    }
    
    struct Output {
        let postResult: Observable<inqueryPostModel>
        let backButtonTapped: Driver<Void>
    }
    struct CommentOnPost {
        let comment: String
    }
    func transform(input: Input) -> Output {
    
        let commentObservable = Observable.combineLatest(input.commentText, input.postItem)
        
        input.commentSendButtonTapped
            .withLatestFrom(commentObservable)
            .flatMap { value, post in
                print("버튼 눌림")
                let item = writeCommentQuery(content: value)
                return NetworkManager.requestNetwork(router: .comment(.writeComment(parameter: item, id: post.post_id)), modelType: WriteCommentModel.self)
            }
            .subscribe { model in
                print(model, "댓글달기 성공")
            } onError: { error in
                print("댓글달기 실패")
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
                      backButtonTapped: input.backButtonTapped.asDriver(onErrorJustReturn: ()))
    }
}
