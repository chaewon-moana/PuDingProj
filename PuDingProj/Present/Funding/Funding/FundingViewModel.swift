//
//  FundingViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FundingViewModel {
    
    let disposeBag = DisposeBag()
    let nextCursor = BehaviorRelay<String>(value: "")
    var tmpResult: [inqueryFundingModel] = []
    let result = PublishRelay<[inqueryFundingModel]>()
    var isLoading = BehaviorRelay(value: false)
    
    struct Input {
        let fundingAddButton: Observable<Void>
        let inputTrigger: Observable<Void>
    }
    
    struct Output {
        let fundingAddButton: Driver<Void>
        let inqueryFunding: Observable<[inqueryFundingModel]>
    }
    
    func transform(input: Input) -> Output {
        input.inputTrigger
            .flatMap { value in
                return NetworkManager.requestNetwork(router: .post(.inqueryPost(next: "", productId: "moana-funding")), modelType: inqueryUpperFundingModel.self)
            }
            .subscribe(with: self) { owner, model in
                print("펀딩포스트 조회 서엉고옹")
               // owner.fetchNextPage()
            } onError: { error, _  in
                print("펀딩포스트 조회 실패애")
            }
            .disposed(by: disposeBag)
        
        
        return Output(fundingAddButton: input.fundingAddButton.asDriver(onErrorJustReturn: ()), inqueryFunding: result.asObservable())
    }
    
    func fetchNextPage() -> Observable<inqueryUpperFundingModel> {
        print("일단 되는지 보자", nextCursor.value)
        //TODO: 다음 페이지 가져와서 보여주기
        isLoading.accept(true)
        let item = NetworkManager.requestNetwork(router: .post(.inqueryPost(next: nextCursor.value, productId: "moana-funding")), modelType: inqueryUpperFundingModel.self).asObservable()
        item.subscribe { model in
            print(model.data)
            self.tmpResult.append(contentsOf: model.data)
            self.result.accept(self.tmpResult)
            self.nextCursor.accept(model.next_cursor)
            self.isLoading.accept(false)
        } onError: { error in
            print(error, "페이지네이션 실패")
        }
        .disposed(by: disposeBag)
    
        return item
    }
}
