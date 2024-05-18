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
    var item: inqueryFundingModel!
    var inputTrigger = PublishRelay<Void>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = SponsorViewModel.Input(inputTrigger: inputTrigger.asObservable(),
                                           fundingButtonTapped: mainView.sponsorButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .drive(with: self) { owner, _ in
                guard let item = owner.item else { return }
                owner.mainView.updateUI(item: item)
            }
            .disposed(by: disposeBag)
        
        output.fundingButtonTapped
            .drive(with: self) { owner, _ in
                //TODO: post-id 넘겨야함
                let vc = FundingPaymentViewController()
                vc.postID = owner.item?.post_id ?? ""
                vc.item = owner.item
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    

}
