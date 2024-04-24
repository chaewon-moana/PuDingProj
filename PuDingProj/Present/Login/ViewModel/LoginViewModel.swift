//
//  JoinViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let joinButtonTapped: Observable<Void>
        let loginButtonTapped: Observable<Void>
        let saveEmailTapped: Observable<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let moveToJoinView: Observable<Void>
        let successToLogin: Observable<Void>
        let saveEmailValue: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let moveToJoin = PublishRelay<Void>()
        let successToLogin = PublishRelay<Void>()
        var email = ""
        let saveEmail = PublishRelay<Bool>()
        
        let loginObservable = Observable.combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                return LoginQuery(email: email, password: password)
            }
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap { query in
                return NetworkManager.requestNetwork(router: .account(.login(query: query)), modelType: LoginModel.self)
            }
            .subscribe { model in
                successToLogin.accept(())
                print("로그인서엉고옹")
                UserDefault.userID = model.user_id
                UserDefault.accessToken = model.accessToken
                UserDefault.refreshToken = model.refreshToken
            } onError: { error in
                //TODO: 확인하라는 alert 창 띄우고, textField 비우기
                print("로그인실패애")
            }
            .disposed(by: disposeBag)

        input.joinButtonTapped
            .bind(to: moveToJoin)
            .disposed(by: disposeBag)
        
        input.saveEmailTapped
            .withLatestFrom(input.emailText)
            .subscribe(with: self) { owner, value in
                if UserDefault.saveEmail.isEmpty {
                    UserDefault.saveEmail = value
                    print(UserDefault.saveEmail, "이메일 저장 됨!")
                    saveEmail.accept(true)
                } else {
                    UserDefault.saveEmail = ""
                    saveEmail.accept(false)
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(moveToJoinView: moveToJoin.asObservable(),
                      successToLogin: successToLogin.asObservable(), saveEmailValue: saveEmail.asObservable())
        
    }
    
    
}
