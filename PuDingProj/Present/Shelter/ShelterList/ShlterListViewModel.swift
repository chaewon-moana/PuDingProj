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
        let buttonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.buttonTap
            .subscribe(with: self) { owner, _ in
                ShelterNetworkManager.shared.request()
            }
            .disposed(by: disposeBag)
        
        
        return Output()
    }
}
