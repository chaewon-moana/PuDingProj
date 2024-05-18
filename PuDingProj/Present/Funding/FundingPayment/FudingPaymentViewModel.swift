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
            .flatMapLatest { (web, postid, item) -> Observable<PaymentValidationModel> in
                return Observable.create { observer in
                    let resultPayment = IamportPayment(
                        pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                        merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
                        amount: "101"
                    ).then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = item.title
                        $0.buyer_name = "조채원"
                        $0.app_scheme = "Puding"
                    }

                    Iamport.shared.paymentWebView(
                        webViewMode: web,
                        userCode: "imp57573124",
                        payment: resultPayment
                    ) { iamportResponse in
                        guard let response = iamportResponse else {
                            observer.onError(NSError(domain: "IamportErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from Iamport"]))
                            return
                        }

                        let impindex = response.imp_uid!
                        let postindex = postid
                        print(impindex, postindex, "결제 진행중인가부다아아아")

                        let price = Int(item.content1!) ?? 0
                        let query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: item.title!, price: 101)
                        print(query, "된건가된건가")

                        observer.onNext(query)
                        observer.onCompleted()
                    }

                    return Disposables.create()
                }
                .flatMap { query in
                  //  print(query, "flatmap 넘어옴")
                    return NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
                    //return result
                }
                .catch { error in
                    print(error, "에러났음..ㅠ")
                    return Observable.empty()
                }
            }
            .subscribe(onNext: { model in
                print(model, "서엉고옹")
            }, onError: { error in
                print("흐음")
            })
            .disposed(by: disposeBag)



//        input.inputTrigger
//            .withLatestFrom(validaionObservable)
//            .flatMap { web, postid, item in
//                return performPaymentValidation(web: web, postid: postid, item: item)
//                    .catch { error in
//                        print(error, "에러났음..ㅠ")
//                        return Observable.empty()
//                    }
//            }
//            .subscribe(onNext: { model in
//                print(model, "서엉고옹")
//            }, onError: { error in
//                print("흐음")
//            })
//            .disposed(by: disposeBag)
//
//        
//    
//        func performPaymentValidation(web: WKWebView, postid: String, item: inqueryFundingModel) -> Observable<PaymentValidationModel> {
//            return Observable.create { observer in
//                let resultPayment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))", amount: "101").then {
//                    $0.pay_method = PayMethod.card.rawValue
//                    $0.name = item.title
//                    $0.buyer_name = "조채원"
//                    $0.app_scheme = "Puding"
//                }
//
//                Iamport.shared.paymentWebView(webViewMode: web, userCode: "imp57573124", payment: resultPayment) { iamportResponse in
//                    guard let response = iamportResponse else {
//                        return
//                    }
//
//                    let impindex = response.imp_uid!
//                    let postindex = postid
//                    print(impindex, postindex, "결제 진행중인가부다아아아")
//
//                    let price = Int(item.content1!) ?? 0
//                    let query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: item.title!, price: 101)
//                    print(query, "된건가된건가")
//
//                    NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self) { result in
//                        switch result {
//                        case .success(let model):
//                            print(model, "result인데 됐어?")
//                            observer.onNext(model)
//                            observer.onCompleted()
//                        case .failure(let error):
//                            print(error, "네트워크 요청 실패")
//                            observer.onError(error)
//                        }
//                    }
//                }
//
//                return Disposables.create()
//            }
//        }

        
//        input.inputTrigger
//            .withLatestFrom(validaionObservable)
//            .flatMap { web, postid, item in
//                
//                var query: PaymentValidationQuery!
//                let resultPayment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",amount: "101").then { //price에 item.content!
//                    $0.pay_method = PayMethod.card.rawValue
//                    $0.name = item.title //결제시 뜨는 이름
//                    $0.buyer_name = "조채원"
//                    $0.app_scheme = "Puding"
//                }
//                Iamport.shared.paymentWebView(webViewMode: web,
//                                              userCode: "imp57573124",
//                                              payment: resultPayment) { [weak self] iamportResponse in
//                    guard let self = self else { return }
//                    guard let response = iamportResponse else { return }
//                    let impindex = response.imp_uid!
//                    let postindex = postid
//                    print(impindex, postindex, "결제 진행중인가부다아아아")
//                    let price = Int(item.content1!) ?? 0
//                    query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: item.title!, price: 101)
//                    print(query, "된건가된건가")
//                    let result = NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self)
//                    print(result, "result인데 됐어?")
//                }
//                
//            }
//            .subscribe { _ in
//                print("흐음")
//            } onError: { error in
//                print("흐음")
//            }
//            .disposed(by: disposeBag)
//        
 

        
        
        
        
        
        
        
        
        
        
        
//        func performPaymentValidation(web: WKWebView, postid: String, item: inqueryFundingModel, completion: @escaping (Result<PaymentValidationModel, Error>) -> Void) {
//            let resultPayment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))", amount: "101").then {
//                $0.pay_method = PayMethod.card.rawValue
//                $0.name = item.title
//                $0.buyer_name = "조채원"
//                $0.app_scheme = "Puding"
//            }
//
//            Iamport.shared.paymentWebView(webViewMode: web, userCode: "imp57573124", payment: resultPayment) { [weak self] iamportResponse in
//                guard let self = self else { return }
//                guard let response = iamportResponse else {
//                    completion(.failure(NSError(domain: "IamportErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from Iamport"])))
//                    return
//                }
//                
//                let impindex = response.imp_uid!
//                let postindex = postid
//                print(impindex, postindex, "결제 진행중인가부다아아아")
//                
//                let price = Int(item.content1!) ?? 0
//                let query = PaymentValidationQuery(imp_uid: impindex, post_id: postindex, productName: item.title!, price: 101)
//                print(query, "된건가된건가")
//                
//                NetworkManager.requestNetwork(router: .payment(.validation(query: query)), modelType: PaymentValidationModel.self) { result in
//                    switch result {
//                    case .success(let model):
//                        print(model, "result인데 됐어?")
//                        completion(.success(model))
//                    case .failure(let error):
//                        print(error, "네트워크 요청 실패")
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }

        
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
////
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
