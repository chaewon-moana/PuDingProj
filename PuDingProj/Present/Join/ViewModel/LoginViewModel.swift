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
    }
    
    func transform(input: Input) -> Output {
        let moveToJoin = PublishRelay<Void>()
        let successToLogin = PublishRelay<Void>()
        var email = ""
    
        let loginObservable = Observable.combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                return LoginQuery(email: email, password: password)
            }
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap { query in
                return NetworkManager.requestNetwork(router: Router.login(query: query), modelType: LoginModel.self)
            }
            .subscribe { model in
                print("로그인서엉고옹")
                UserDefaults.standard.set(model.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(model.refreshToken, forKey: "refreshToken")
            } onError: { error in
                //TODO: 확인하라는 alert 창 띄우고, textField 비우기
                print("로그인실패애")
            }
            .disposed(by: disposeBag)
        
        input.emailText
            .map{ value in
                email = value
            }

        
        input.joinButtonTapped
            .bind(to: moveToJoin)
            .disposed(by: disposeBag)
        
        input.loginButtonTapped
            .bind(to: successToLogin)
            .disposed(by: disposeBag)
        
        input.saveEmailTapped
            .subscribe(with: self) { owner, _ in
                UserDefaults.standard.setValue(email, forKey: "userEmail")
            }
            .disposed(by: disposeBag)
        
        return Output(moveToJoinView: moveToJoin.asObservable(),
                      successToLogin: successToLogin.asObservable())
        
    }
    
    
}
