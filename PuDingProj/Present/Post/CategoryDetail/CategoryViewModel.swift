//
//  CategoryViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CategoryViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let categorySelected: ControlEvent<categoryData>
        
    }
    
    struct Output {
        let categoryDismiss: Observable<String>
        
    }
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<String>()
        
        input.categorySelected
            .subscribe { value in
                result.accept(value.element!.rawValue)
            }
            .disposed(by: disposeBag)
        
        return Output(categoryDismiss: result.asObservable())
    }
}
