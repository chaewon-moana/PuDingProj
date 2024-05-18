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
    
//    var payment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
//            amount: "47900").then {
//        $0.pay_method = PayMethod.card.rawValue
//        $0.name = "피니키 하이포 알러지 연어 강아지 피부 눈물 가수분해 사료" //결제시 뜨는 이름
//        $0.buyer_name = "moana22"
//        $0.app_scheme = "Puding"
//    }
    
    struct Input {
        var inputTrigger: Observable<Void>
        var inputPostId: Observable<String>
        let inputWebView: Observable<WKWebView>
        let inputItem: Observable<inqueryFundingModel>
    }
    
    struct Output {
        let outputTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validaionObservable = Observable.combineLatest(input.inputWebView, input.inputPostId, input.inputItem)
        let impId = PublishRelay<String>()
//        let postId = PublishRelay<String>()
//        let tmpObservable = Observable.combineLatest(impId.asObservable(), input.inputPostId)
        var query = PaymentValidationQuery(imp_uid: "", post_id: "", productName: "", price: 0)
//        var resultPayment = input.inputItem
//            .subscribe(with: self) { owner, model in
//                let price = Int(model.content1 ?? "0")!
//                owner.payment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",amount: model.content1!).then {
//                    $0.pay_method = PayMethod.card.rawValue
//                    $0.name = model.title //결제시 뜨는 이름
//                    $0.buyer_name = "moana22"
//                    $0.app_scheme = "Puding"
//                }
//            }
        
        input.inputTrigger
            .withLatestFrom(validaionObservable)
            .flatMap { web, postid, item in
                //var query: PaymentValidationQuery!
                let resultPayment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",amount: "101").then { //price에 item.content!
                    $0.pay_method = PayMethod.card.rawValue
                    $0.name = item.title //결제시 뜨는 이름
                    $0.buyer_name = "조채원"
                    $0.app_scheme = "Puding"
                }
                Iamport.shared.paymentWebView(webViewMode: web,
                                              userCode: "imp57573124", 
                                              payment: resultPayment) { [weak self] iamportResponse in
                    guard let self = self else { return }
                    guard let response = iamportResponse else { return }
                    let impindex = response.imp_uid!
                    let postindex = postid
                    print(impindex, postindex, "결제 진행중인가부다아아아")
                    let price = Int(item.content1!) ?? 0
                    query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: item.title!, price: 101)
                    print(query, "된건가된건가")
                }
                print(query, "된건가")
                let result = NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
                print(result, "리저트인데 된건가")
                return result
            }
            .subscribe { model in
                print(model, "결제 잘 됐음")
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)


        
//        input.inputTrigger
//            .withLatestFrom(validaionObservable)
//            .flatMap { web, postid -> Observable<String> in
//                return Observable.create { observer in
//                    print("출력된다느으으응!")
//                    var impindex = ""
//                    var postindex = ""
//                    Iamport.shared.paymentWebView(
//                        webViewMode: web,
//                        userCode: "imp57573124",
//                        payment: self.payment) { [weak self] iamportResponse in
//                            guard let self = self else { return }
//                            print(String(describing: iamportResponse), "이게 언제 출력되나요?")
//                            
//                            guard let response = iamportResponse else {
//                                return
//                            }
//                            impindex = response.imp_uid!
//                            postindex = postid
//                            let query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: "피니키 하이포 알러지 연어 강아지 피부 눈물 가수분해 사료", price: 47900)
//                            let result = NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
//                            
//                            observer.onNext(impindex) // 결과를 옵저버에게 전달
//                            observer.onCompleted()
//                    }
//                    return Disposables.create()
//                }
//            }
//            .subscribe { impId in
//                print(impId, "됐따앙")
//            } onError: { error in
//                print(error, "에러발새앵")
//            }
//            .disposed(by: disposeBag)
//
//
//     
        
        input.inputPostId
            .subscribe { value in
                print(value, "post id 에욤")
            }
            .disposed(by: disposeBag)
        
        return Output(outputTrigger: input.inputTrigger.asDriver(onErrorJustReturn: ()))
    }
}
