//
//  FundingPaymentViewController.swift
//  PuDingProj
//
//  Created by cho on 5/10/24.
//

import UIKit
import WebKit
import SnapKit
import iamport_ios
import RxSwift

final class FundingPaymentViewController: BaseViewController {
    
    let viewModel = FudingPaymentViewModel()
    var inputTrigger: () = ()
    var postID: String = ""
    var item: inqueryFundingModel!

    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger = ()
    }
    
    override func bind() {
        let trigger = BehaviorSubject(value: inputTrigger)
        let postIDObservable = BehaviorSubject(value: postID)
        let itemObservable = BehaviorSubject(value: item!)
        let webView = BehaviorSubject(value: wkWebView)
        
        let input = FudingPaymentViewModel.Input(inputTrigger: trigger.asObservable(),
                                                 inputPostId: postIDObservable.asObservable(),
                                                 inputWebView: webView.asObservable(),
                                                 inputItem: itemObservable.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.outputTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureView()
    }
    
    private func congifureView() {
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
