//
//  CommunityViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommunityViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: Observable<Void>
    }
    
    struct Output {
        let inqueryResult: Observable<inqueryUppperPostModel>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<inqueryUppperPostModel>()
        
        let inquery = Observable.just("puding-moana22")//product_id
            .map { value in
                return InquiryPostQuery(product_id: value)
            }
        
        input.inputTrigger
            .withLatestFrom(inquery)
            .flatMap { value in
                return NetworkManager.requestPostText()
            }
            .subscribe { model in
                print("포스트 조회 서엉고옹")
                result.accept(model)
            } onError: { error in
                print("포스트 조회 실패애")
            }
            .disposed(by: disposeBag)
            
        return Output(inqueryResult: result.asObservable())
    }
}
