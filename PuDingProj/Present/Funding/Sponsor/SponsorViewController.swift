//
//  SponsorViewController.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SponsorViewController: BaseViewController {

    let mainView = SponsorView()
    let viewModel = SponsorViewModel()
    var item: inqueryFundingModel?
    var inputTrigger = PublishRelay<Void>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.accept(())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func bind() {
        let input = SponsorViewModel.Input(inputTrigger: inputTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .drive(with: self) { owner, _ in
                guard let item = owner.item else { return }
                owner.mainView.updateUI(item: item)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    

}
