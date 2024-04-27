//
//  EditMyInfoViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditMyInfoViewModel {

    let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: Observable<Void>
    }
    
    struct Output {
        let inputTrigger: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(inputTrigger: input.inputTrigger)
    }
}

