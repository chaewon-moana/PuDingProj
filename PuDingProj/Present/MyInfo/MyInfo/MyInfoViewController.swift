//
//  MyInfoViewController.swift
//  PuDingProj
//
//  Created by cho on 4/13/24.
//

import UIKit
import RxCocoa
import RxSwift

class MyInfoViewController: BaseViewController {

    let mainView = MyInfoView()
    let viewModel = MyInfoViewModel()

    var trigger: () = ()
    
    override func loadView() {
        view = mainView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trigger = ()
    }
    override func bind() {
        let inputTrigger = Observable.of(trigger)
        
        let input = MyInfoViewModel.Input(inputTrigger: inputTrigger,
                                          withdrawButtonTapped: mainView.withdrawButton.rx.tap.asObservable(),
                                          settingButtonTapped: mainView.settingButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .subscribe(with: self) { owner, model in
                owner.mainView.updateUI(item: model)
            }
            .disposed(by: disposeBag)
        
        output.moveToEditInfo
            .subscribe(with: self) { owner, model in
                let vc = EditMyInfoViewController()
                vc.item = model
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
