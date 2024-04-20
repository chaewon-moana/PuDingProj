//
//  LoginViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class JoinViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: Observable<String>
        let email: Observable<String>
        let password: Observable<String>
        let phoneNum: Observable<String>
        let inputButtonTapped: Observable<Void>
        let duplicationButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let emailValidation: Driver<Bool>
        let joinSuccessTrigger: Driver<Void>
        let emailValidationButton: Driver<Void>
        let joinButtonValid: Driver<Bool>
        let backButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let joinSuccessTrigger = PublishRelay<Void>()
        let emailValid = BehaviorRelay(value: false)
        let emailValue = BehaviorRelay(value: "")
        let emailValidation = PublishRelay<Void>()
        let checkDuplicationButton = BehaviorRelay(value: false)
        
        let joinObservable = Observable.combineLatest(input.email, input.nickname, input.password, input.phoneNum)
            .map { email, nickname, password, phoneNum in
                return JoinQuery(email: email, password: password, nick: nickname, phoneNum: phoneNum)
            }
        
        //TODO: Observable을 String으로 바꾸는게 없나?
        let emailObservable = input.email
            .map { email in
                return emailQuery(email: email)
           }
        
        
        input.duplicationButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(emailObservable)
            .flatMap { value in
                print(value, "여기는 되는데,,,")
                return NetworkManager.requestNetwork(router: AccountRouter.emailValidation(email: value), modelType: emailValidationModel.self)
                //return NetworkManager.checkEmailValidation(email: value)
            }
            .subscribe(with: self) { owner, emailModel in
                print(emailModel, "이메일 중복확인 성공")
                checkDuplicationButton.accept(true)
                emailValidation.accept(())
            
            } onError: { emailModel, error in
                print("이메일 중복확인 실패")
                print(emailModel, error)
                emailValidation.accept(())
            }
            .disposed(by: disposeBag)
        
        emailObservable
            .bind(with: self) { owner, value in
                if value.email.contains("@") && value.email.contains(".") {
                    emailValid.accept(true)
                    emailValue.accept(value.email)
                } else {
                    emailValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        let joinValid = Observable.combineLatest(input.nickname, input.password, input.phoneNum, emailValid, checkDuplicationButton)
            .map { nickname, password, phoneNum, email, checkButton in
                if !nickname.isEmpty && !password.isEmpty && !phoneNum.isEmpty && email && checkButton {
                    return true
                } else {
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
            
    input.inputButtonTapped
        .debounce(.seconds(1), scheduler: MainScheduler.instance)
        .withLatestFrom(joinObservable)
        .flatMap { joinQuery in
            print(joinQuery)
            return NetworkManager.requestNetwork(router: AccountRouter.join(query: joinQuery), modelType: JoinModel.self)
        }
        .subscribe(with: self) { owner, joinModel in
            print(joinModel)
            joinSuccessTrigger.accept(())
        } onError: { joinModel, error in
            print("오류발생")
            print(error)
        }
        .disposed(by: disposeBag)
        
        return Output(emailValidation: emailValid.asDriver(),
                      joinSuccessTrigger: joinSuccessTrigger.asDriver(onErrorJustReturn: ()),
                      emailValidationButton: emailValidation.asDriver(onErrorJustReturn: ()), 
                      joinButtonValid: joinValid.asDriver(), 
                      backButtonTapped: input.backButtonTapped.asDriver(onErrorJustReturn: ())
        )
    }
}
