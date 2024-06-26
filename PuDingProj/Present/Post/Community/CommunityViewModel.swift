//
//  CommunityViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommunityViewModel {
    
    let disposeBag = DisposeBag()
    let nextCursor = BehaviorRelay<String>(value: "0")
    var tmpResult: [inqueryPostModel] = []
    let result = PublishRelay<[inqueryPostModel]>()
    var isLoading = BehaviorRelay(value: false)
    
    struct Input {
        let inputTrigger: PublishRelay<Void>
        let searchText: Observable<String>
        let searchButtonTapped: Observable<Void>
        let postSelected: ControlEvent<inqueryPostModel>
        let pagination: Observable<Void>
    }
    
    struct Output {
        let inqueryResult: Observable<[inqueryPostModel]>
        let specificPost: Observable<inqueryPostModel>
        let moveToDetail: Observable<inqueryPostModel>
        let inputTrigger: Observable<[inqueryPostModel]>
    }
    
    func transform(input: Input) -> Output {
        let specificResult = PublishRelay<inqueryPostModel>()
        let moveToDetail = PublishRelay<inqueryPostModel>()
    
        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .flatMap { value in
                let item = SpecificPostQuery(next: nil, limit: nil, post_id: value)
                return NetworkManager.requestNetwork(router: .post(.inquerySpecificPost(id: value)), modelType: inqueryPostModel.self)
            }
            .subscribe { model in
                print(model, "특정 포스트 조회 성공")
                specificResult.accept(model)
            } onError: { error in
                print(error, "특정 포스트 조회 실패")
            }
            .disposed(by: disposeBag)

        input.postSelected
            .subscribe(with: self) { owner, model in
                print(model, "포스트 모델 선택되긴 함")
                moveToDetail.accept(model)
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        input.inputTrigger
            .flatMap { value in
                return NetworkManager.requestNetwork(router: .post(.inqueryPost(next: "0", productId: ProductID.PostId.rawValue)), modelType: inqueryUppperPostModel.self)
            }
            .subscribe(with: self) { owner, model in
                owner.tmpResult = []
                owner.tmpResult.append(contentsOf: model.data)
                owner.result.accept(owner.tmpResult)
                owner.nextCursor.accept(model.next_cursor)
            } onError: { error, _  in
                print("포스트 조회 실패애")
            }
            .disposed(by: disposeBag)
        
        
        input.pagination
            .subscribe(with: self, onNext: { owner, _ in
                owner.fetchNextPage()
            })
            .disposed(by: disposeBag)
  
        
        return Output(inqueryResult: result.asObservable(), 
                      specificPost: specificResult.asObservable(),
                      moveToDetail: moveToDetail.asObservable(), 
                      inputTrigger: result.asObservable()
        )
    }
    
    @discardableResult
    func fetchNextPage() -> Observable<inqueryUppperPostModel> {
        isLoading.accept(true)
        let item = NetworkManager.requestNetwork(router: .post(.inqueryPost(next: nextCursor.value, productId: "puding-moana22")), modelType: inqueryUppperPostModel.self).asObservable()
        item.subscribe { model in
            self.tmpResult.append(contentsOf: model.data)
            self.result.accept(self.tmpResult)
            self.nextCursor.accept(model.next_cursor)
        } onError: { error in
            print(error, "페이지네이션 실패")
        }
        .disposed(by: disposeBag)
    
        return item
    }
 
}
