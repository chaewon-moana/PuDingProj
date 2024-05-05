//
//  SponsorViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SponsorViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: Observable<Void>
    }
    
    struct Output {
        let inputTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(inputTrigger: input.inputTrigger.asDriver(onErrorJustReturn: ()))
    }
}
