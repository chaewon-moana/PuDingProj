//
//  LoginViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: Observable<String>
        let email: Observable<String>
        let password: Observable<String>
        let phoneNum: Observable<String>
        let inputButtonTapped: Observable<Void>
    }
    
    struct Output {
        let loginSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let loginSuccessTrigger = PublishRelay<Void>()
        
        let loginObservable = Observable.combineLatest(input.email, input.nickname, input.password, input.phoneNum)
            .map { email, nickname, password, phoneNum in
                return JoinQuery(email: email, password: password, nick: nickname, phoneNum: phoneNum)
            }
        
        input.inputButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap { joinQuery in
                print(joinQuery)
                return NetworkManager.joinMember(query: joinQuery)
            }
            .subscribe(with: self) { owner, joinModel in
                print(joinModel)
                loginSuccessTrigger.accept(())
            } onError: { onwer, error in
                print("오류발생")
                print(error)
            }
            .disposed(by: disposeBag)
        
        
        return Output(loginSuccessTrigger: loginSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}
