//
//  LoginViewController.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        
//        output.emailValidationButton
//            .drive(with: self) { owner, value in
//                print(value, "중복버튼 확인 완")
//            }
//            .disposed(by: disposeBag)
        
        output.backButtonTapped
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

