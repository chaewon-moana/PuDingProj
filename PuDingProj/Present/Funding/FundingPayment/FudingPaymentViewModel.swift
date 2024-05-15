//
//  FudingPaymentViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

final class FudingPaymentViewModel {
    
    let disposeBag = DisposeBag()
    
    let payment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
            amount: "47900").then {
        $0.pay_method = PayMethod.card.rawValue
        $0.name = "피니키 하이포 알러지 연어 강아지 피부 눈물 가수분해 사료" //결제시 뜨는 이름
        $0.buyer_name = "moana22"
        $0.app_scheme = "Puding"
    }
    
    struct Input {
        var inputTrigger: Observable<Void>
        var inputPostId: Observable<String>
        let inputWebView: Observable<WKWebView>
    }
    
    struct Output {
        let outputTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validaionObservable = Observable.combineLatest(input.inputWebView, input.inputPostId)
        let impId = PublishRelay<String>()
        let postId = PublishRelay<String>()
        let tmpObservable = Observable.combineLatest(impId.asObservable(), input.inputPostId)
        
        
        input.inputTrigger
            .withLatestFrom(validaionObservable)
            .flatMap { web, postid -> Observable<String> in
                return Observable.create { observer in
                    print("출력된다느으으응!")
                    var impindex = ""
                    var postindex = ""
                    Iamport.shared.paymentWebView(
                        webViewMode: web,
                        userCode: "imp57573124",
                        payment: self.payment) { [weak self] iamportResponse in
                            guard let self = self else { return }
                            print(String(describing: iamportResponse), "이게 언제 출력되나요?")
                            
                            guard let response = iamportResponse else {
                                return
                            }
                            impindex = response.imp_uid!
                            postindex = postid
                            let query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: "피니키 하이포 알러지 연어 강아지 피부 눈물 가수분해 사료", price: 47900)
                            let result = NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
                            
                            observer.onNext(impindex) // 결과를 옵저버에게 전달
                            observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .subscribe { impId in
                print(impId, "됐따앙")
            } onError: { error in
                print(error, "에러발새앵")
            }
            .disposed(by: disposeBag)
//        input.inputTrigger
//            .withLatestFrom(validaionObservable)
//            .flatMap { web, postid in
//                print("출력된다느으으응!")
//                var impindex = ""
//                var postindex = ""
//                Iamport.shared.paymentWebView (
//                    webViewMode: web,
//                    userCode: "imp57573124",
//                    payment: self.payment) { [weak self] iamportResponse in
//                        guard let self else { return }
//                        print(String(describing: iamportResponse), "이게 언제 출력되나요?")
//                        
//                        guard let response = iamportResponse else { return }
//                        impindex = response.imp_uid!
//                        postindex = postid
//                        let query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: "후원", price: 100)
//                        let result = NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
//                    }
//              
//            }
//            .subscribe { impId in
//                print(impId, "됐따앙")
//               
//            } onError: { error in
//                print(error, "에러발새앵")
//            }
//            .disposed(by: disposeBag)
//

     
        
        input.inputPostId
            .subscribe { value in
                print(value, "post id 에욤")
            }
            .disposed(by: disposeBag)
        
        return Output(outputTrigger: input.inputTrigger.asDriver(onErrorJustReturn: ()))
    }
}
