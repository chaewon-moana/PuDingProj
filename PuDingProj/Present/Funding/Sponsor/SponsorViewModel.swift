//
//  SponsorViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios
import Then

final class SponsorViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: Observable<Void>
        let fundingButtonTapped: Observable<Void>
    }
    
    struct Output {
        let inputTrigger: Driver<Void>
        let fundingButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
//        input.fundingButtonTapped
//            .subscribe(with: self) { owner, _ in
//                let payment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
//                        amount: "1000000").then { 
//                    $0.pay_method = PayMethod.card.rawValue 
//                    $0.name = "후원"
//                    $0.buyer_name = "moana22"
//                    $0.app_scheme = "Puding"
//                }
//            }
//            .disposed(by: disposeBag)
        
        
        return Output(inputTrigger: input.inputTrigger.asDriver(onErrorJustReturn: ()), fundingButtonTapped: input.fundingButtonTapped.asDriver(onErrorJustReturn: ()))
    }
}
