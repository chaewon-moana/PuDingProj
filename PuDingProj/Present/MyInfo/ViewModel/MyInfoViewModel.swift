//
//  MyInfoViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyInfoViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: Observable<Void>
        let withdrawButtonTappend: Observable<Void>
    }
    
    struct Output {
        let profileInfo: Observable<InqueryProfileModel>
    }

    func transform(input: Input) -> Output {
        let profile = PublishRelay<InqueryProfileModel>()
        
        input.inputTrigger
            .flatMap { _ in
                return NetworkManager.requestNetwork(router: .profile(.inqueryProfile), modelType: InqueryProfileModel.self)
            }
            .subscribe { model in
                print("MyInfo Input Trigger 발생 에러에러")
                print(model, "모데에엘")
                profile.accept(model)
            } onError: { error in
                print(error, "모델 에러 생김")
            }
            .disposed(by: disposeBag)
        
        input.withdrawButtonTappend
            .flatMap { _ in
                return NetworkManager.requestNetwork(router: .account(.withdraw), modelType: CreatorInfo.self)
            }
            .subscribe { model in
                print(model, "탈퇴 완료")
            } onError: { error in
                print(error, "탈퇴 실패")
            }
            .disposed(by: disposeBag)

        
        return Output(profileInfo: profile.asObservable())
    }
}
