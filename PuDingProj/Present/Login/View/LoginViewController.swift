//
//  LoginViewController.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {

    let mainView = LoginView()
    let viewModel = LoginViewModel()
        
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func bind() {
        let input = LoginViewModel.Input(nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                         email: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                         password: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                         phoneNum: mainView.phoneNumTextField.rx.text.orEmpty.asObservable(), 
                                         inputButtonTapped: mainView.button.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        output.loginSuccessTrigger
            .drive(with: self) { owner, _ in
                
            }
            .disposed(by: disposeBag)
        
    }
 
    
    

}
