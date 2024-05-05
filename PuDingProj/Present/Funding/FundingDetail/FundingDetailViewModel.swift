//
//  FundingDetailViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class FundingDetailViewModel {
    
    let disposeBag = DisposeBag()
    var images: BehaviorRelay<[Data?]> = BehaviorRelay(value: [])
    let targetValue = BehaviorRelay(value: "")
    let dueDateValue = BehaviorRelay(value: "")
    struct Input {
        let addImageButton: Observable<Void>
        let saveFundingPost: Observable<Void>
        
        let productNameText: Observable<String>
        let productPriceText: Observable<String>
        let targetText: Observable<String>
        let dueDateText: Observable<String>
        let shelterText: Observable<String>
        let productImage: Observable<[Data?]>
        
    }
    
    struct Output {
        let addImageButton: Driver<Void>
        let saveButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let uploadedImages = PublishRelay<UploadPostImageFilesModel>()
        let saveButtonTapped = PublishRelay<Void>()

        let fundingObservable = Observable.combineLatest(input.productNameText, input.productPriceText, targetValue.asObservable(), dueDateValue.asObservable(), input.shelterText, uploadedImages)
        
        input.saveFundingPost
            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
                guard let self = self else { return .empty() }
                let images = self.images.value
                
                guard !images.isEmpty else {
                    let emptyFiles: [Data] = [] // 빈 배열로 초기화
                    let uploadQuery = UploadPostImageFilesQuery(files: emptyFiles)
                    return .just(uploadQuery)
                }
                return Observable.of(images)
                    .map { images in
                        print(images, "이젠 되게찌")
                        return UploadPostImageFilesQuery(files: images)
                    }
            }
            .map { value in
                print(value, "뷰모델에서 확인")
                let multipartFormData = MultipartFormData()
                for data in value.files {
                    multipartFormData.append(data!,
                                             withName: "files",
                                             fileName: "moana\(UUID()).jpg",
                                             mimeType: "image/jpg")
                }
                print(value, "데이터 확인")
                return multipartFormData
            }
            .flatMap { data in
                return NetworkManager.requestUploadImage(query: data)
            }
            .map { model in
                uploadedImages.accept(model)
            }
            .withLatestFrom(fundingObservable)
            .flatMap { name, price, target, dueDate, shelter, image  in
                let query = RegisterFundungQuery(title: name, content: "내용만들기", content1: price, content2: target, content3: dueDate, content4: shelter, product_id: "moana-funding", files: image.files)
                return NetworkManager.requestNetwork(router: .post(.registerFunding(query: query)), modelType: RegisterFundingModel.self)
            }
            .subscribe { model in
                print(model, "포스트 등록 성공")
                saveButtonTapped.accept(())
            } onError: { error in
                print("포스트 등록 실패")
            }
            .disposed(by: disposeBag)
        
        return Output(addImageButton: input.addImageButton.asDriver(onErrorJustReturn: ()),
                      saveButtonTapped: saveButtonTapped.asDriver(onErrorJustReturn: ()))
    }
}
