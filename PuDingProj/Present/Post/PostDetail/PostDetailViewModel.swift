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
    }
    
    struct Output {
        let postResult: Observable<inqueryPostModel>
        let backButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        

        
        
        
        return Output(postResult: input.postItem,
                      backButtonTapped: input.backButtonTapped.asDriver(onErrorJustReturn: ()))
    }
}
