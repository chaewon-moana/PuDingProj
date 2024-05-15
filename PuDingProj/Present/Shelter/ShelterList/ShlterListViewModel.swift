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
    }
    
    struct Output {
        let itemList: Observable<ShelterResponse>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<ShelterResponse>()
        
        input.Trigger
            .subscribe(with: self) { owner, _ in
                ShelterNetworkManager.shared.request { response in
                    result.accept(response.response)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(itemList: result.asObservable())
    }
}
