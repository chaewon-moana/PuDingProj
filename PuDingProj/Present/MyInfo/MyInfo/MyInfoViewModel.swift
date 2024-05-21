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
        let withdrawButtonTapped: Observable<Void>
        let settingButtonTapped: Observable<Void>
        let moveChat: Observable<Void>
    }
    
    struct Output {
        let profileInfo: Observable<InqueryProfileModel>
        let moveToEditInfo: Observable<InqueryProfileModel>
        let resultList: Driver<[RegisterPostModel]>
        let moveToChat: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let profile = PublishRelay<InqueryProfileModel>()
        let editProfile = PublishRelay<InqueryProfileModel>()
        let postList = PublishRelay<[String]>()
        let resultPostList = PublishRelay<[RegisterPostModel]>()
        
        input.inputTrigger
            .flatMap { _ in
                return NetworkManager.requestNetwork(router: .profile(.inqueryProfile), modelType: InqueryProfileModel.self)
            }
            .subscribe { model in
                print(model, "모데에엘")
                profile.accept(model)
                postList.accept(model.posts)
            } onError: { error in
                print(error, "모델 에러 생김")
            }
            .disposed(by: disposeBag)
        
        postList
            .flatMap { values in
               // print("여기까지 왔나?", values)
                Observable.from(values)
                    .flatMap { value -> PrimitiveSequence<SingleTrait, RegisterPostModel> in
                        print("여긴 됨?", value)
                      let item = NetworkManager.requestNetwork(router: .post(.inquerySpecificPost(id: value)), modelType: RegisterPostModel.self)
                        return item
                    }
                    .filter { $0.product_id == "puding-moana22" }
                    .toArray()
                    .map { $0.reversed() }
            }
            .subscribe(onNext: { arrayOfRegisterPostModels in
                print("받아온 RegisterPostModel 배열:", arrayOfRegisterPostModels)
                resultPostList.accept(arrayOfRegisterPostModels)
            }, onError: { error in
                print("에러 발생:", error)
            })
            .disposed(by: disposeBag)
        
        
        input.withdrawButtonTapped
            .flatMap { _ in
                return NetworkManager.requestNetwork(router: .account(.withdraw), modelType: CreatorInfo.self)
            }
            .subscribe { model in
                print(model, "탈퇴 완료")
            } onError: { error in
                print(error, "탈퇴 실패")
            }
            .disposed(by: disposeBag)

        input.settingButtonTapped
            .flatMap { _ in
                return NetworkManager.requestNetwork(router: .profile(.inqueryProfile), modelType: InqueryProfileModel.self)
            }
            .subscribe { model in
                editProfile.accept(model)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)

        return Output(profileInfo: profile.asObservable(),
                      moveToEditInfo: editProfile.asObservable().asObservable(),
                      resultList: resultPostList.asDriver(onErrorJustReturn: []),
                      moveToChat: input.moveChat.asDriver(onErrorJustReturn: ()))
    }
}
