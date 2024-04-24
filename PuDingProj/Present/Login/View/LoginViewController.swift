//
//  JoinViewController.swift
//  PuDingProj
//
//  Created by cho on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
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
        let input = LoginViewModel.Input(joinButtonTapped: mainView.joinButton.rx.tap.asObservable(),
                                         loginButtonTapped: mainView.loginButton.rx.tap.asObservable(),
                                         saveEmailTapped: mainView.checkBox.rx.tap.asObservable(),
                                         emailText: mainView.emailTextField.rx.text.orEmpty,
                                         passwordText: mainView.passwordTextField.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input: input)
        
        output.moveToJoinView
            .subscribe(with: self) { owner, _ in
                print("버튼 눌린지 확인")
                //TODO: 처리하고 돌아올 떄, view 쌓여있지 않도록 만들기
                //보통 present로 만드는거 같음
                let vc = UINavigationController(rootViewController: JoinViewController())
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
                //owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.successToLogin
            .subscribe(with: self) { owner, _ in
                print("로그인 성공해서 뷰로 넘어감~~")
                let vc = MainTabBarController()
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.saveEmailValue
            .bind(with: self) { owner, value in
                owner.mainView.checkBox.tintColor = value ? .blue : .gray
            }
            .disposed(by: disposeBag)
        
    }
}


