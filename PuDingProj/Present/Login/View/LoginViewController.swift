//
//  LoginViewController.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

    let mainView = LoginView()
    let viewModel = LoginViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        view.backgroundColor = .white
    }

    private func bind() {
        let input = LoginViewModel.Input(nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                         email: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                         password: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                         phoneNum: mainView.phoneNumTextField.rx.text.orEmpty.asObservable(), 
                                         inputButtonTapped: mainView.button.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        output.loginSuccessTrigger
            .drive(with: self) { owner, _ in
                
            }
        
    }
 
    
    

}
