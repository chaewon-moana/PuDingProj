//
//  FudingPaymentViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class FudingPaymentViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        var inputTrigger: Observable<Void>
        var inputPostId: Observable<String>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.inputTrigger
            .subscribe { _ in
                print("출력된다느으으응!")
            }
            .disposed(by: disposeBag)
        
        input.inputPostId
            .subscribe { value in
                print(value, "post id 에욤")
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
