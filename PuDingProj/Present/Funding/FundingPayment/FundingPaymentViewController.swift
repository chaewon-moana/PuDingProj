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

    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger = ()
    }
    
    let payment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
            amount: "100").then {
        $0.pay_method = PayMethod.card.rawValue
        $0.name = "후원" //결제시 뜨는 이름
        $0.buyer_name = "moana22"
        $0.app_scheme = "Puding"
    }

    override func bind() {
        let trigger = BehaviorSubject(value: inputTrigger)
        let postIDObservable = BehaviorSubject(value: postID)
        
        let input = FudingPaymentViewModel.Input(inputTrigger: trigger.asObservable(),
                                                 inputPostId: postIDObservable.asObservable())
        
        let output = viewModel.transform(input: input)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureView()
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: "imp57573124",
            payment: payment) { [weak self] iamportResponse in
                guard let self else { return }
                print(String(describing: iamportResponse), "이게 언제 출력되나요?")
                guard let response = iamportResponse else { return }
                let query = PaymentValidationQuery(imp_uid: response.imp_uid!, post_id: "663dd747a26cbbd86f3aa600", productName: "후원", price: 100)
                let result = NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
                print(result, "결제 validation")
                self.dismiss(animated: true)
            }
    }
    
    private func congifureView() {
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

   

}
