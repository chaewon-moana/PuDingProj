//
//  LoginViewController.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class JoinViewController: BaseViewController {

    let mainView = JoinView()
    let viewModel = JoinViewModel()
    lazy var backButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: nil)
        view.tintColor = .black
        return view
    }()
        
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = backButton
    }

    override func bind() {
        let input = JoinViewModel.Input(nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                         email: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                         password: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                         phoneNum: mainView.phoneNumTextField.rx.text.orEmpty.asObservable(), 
                                        inputButtonTapped: mainView.button.rx.tap.asObservable(), 
                                        duplicationButtonTapped: mainView.emailValidationButton.rx.tap.asObservable(),
                                        backButtonTapped: backButton.rx.tap.asObservable()
        
        )
        
        let output = viewModel.transform(input: input)
        
        output.joinButtonValid
            .map { value in
                value ? .systemYellow : .lightGray
            }
            .drive(mainView.button.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.joinButtonValid
            .drive(mainView.button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidation
            .drive(mainView.emailValidationButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidationButton
            .drive(with: self) { owner, value in
                owner.toast()
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.joinSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func toast() {
        var style = ToastStyle()
        style.messageColor = .systemYellow
        self.view.makeToast("이메일 인증 성공했습니다.", duration: 2.0, position: .center, style: style)
    }
}




