//
//  ShlterListViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShelterListViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let Trigger: Observable<Void>
        let paginationTrigger: Observable<Void>
    }
    
    struct Output {
        let itemList: Observable<[Item]>
        let nextPage: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<[Item]>()
        var tmpResult: [Item] = []
        let nextPage = PublishRelay<Int>()
        
        input.Trigger
            .subscribe(with: self) { owner, _ in
                ShelterNetworkManager.shared.request(pageNo: 1) { response in
                    tmpResult = response.response.body.items.item
                    result.accept(tmpResult)
                    nextPage.accept(response.response.body.pageNo+1)
                }
            }
            .disposed(by: disposeBag)
        
        input.paginationTrigger
            .withLatestFrom(nextPage)
            .subscribe { value in
                ShelterNetworkManager.shared.request(pageNo: value) { response in
                    tmpResult.append(contentsOf: response.response.body.items.item)
                    result.accept(response.response.body.items.item)
                    nextPage.accept(response.response.body.pageNo+1)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(itemList: result.asObservable(), nextPage: nextPage.asDriver(onErrorJustReturn: 0))
    }
}
