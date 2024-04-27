//
//  EditMyInfoViewController.swift
//  PuDingProj
//
//  Created by cho on 4/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditMyInfoViewController: BaseViewController {

    var item: InqueryProfileModel?
    let viewModel = EditMyInfoViewModel()
    let mainView = EditMyInfoView()
    var trigger: () = ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trigger = ()
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func bind() {
        let inputTrigger = Observable.of(trigger)
        
        let input = EditMyInfoViewModel.Input(inputTrigger: inputTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .subscribe(with: self) { owner, _ in
                owner.mainView.updateUI(data: owner.item!)
            }
            .disposed(by: disposeBag)
    }
}
