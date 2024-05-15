//
//  RegistPostViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI
import Alamofire

final class RegistPostViewModel {
    
    let disposeBag = DisposeBag()
    var images: BehaviorRelay<[Data?]> = BehaviorRelay(value: [])
    var tmp: Int = 0
    
    struct Input {
        let postData: Observable<String> //title, content, content1
        let titleText: Observable<String>
        let contentText: Observable<String>
        let addImageButtonTapped: Observable<Void>
        let imageList: BehaviorRelay<[Data?]>
        let inputSaveButtonTapped: Observable<Void>
        let categoryButtonTapped: Observable<Void>
        let cancalButtonTapped: Observable<Void>
        let inputTrigger: Observable<Void>
    }
    
    struct Output {
        let presentImagePickerView: Driver<Void>
        let categoryHalfModal: Driver<Void>
        let cancelButtonTapped: Driver<Void>
        let savePost: Driver<Void>
    }
    
    func updateImageList(value: [Data?]) {
        images.accept(value)
    }
    
    func transform(input: Input) -> Output {
        let emptyImage = BehaviorRelay<[String]>(value: [])
        let uploadedImages = PublishRelay<UploadPostImageFilesModel>()
        let postObservable = Observable.combineLatest(uploadedImages, input.titleText, input.contentText, input.postData)
        
        let saveDone = PublishRelay<Void>()
        
        input.inputSaveButtonTapped
            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
                guard let self = self else { return .empty() }
                let images = self.images.value
                let uploadQuery: UploadPostImageFilesQuery
                if images.isEmpty {
                    uploadQuery = UploadPostImageFilesQuery(files: [])
                } else {
                    uploadQuery = UploadPostImageFilesQuery(files: images)
                }
                return .just(uploadQuery)
            }
            .flatMap { uploadQuery -> Observable<UploadPostImageFilesModel> in
                if uploadQuery.files.isEmpty {
                    let emptyModel = UploadPostImageFilesModel(files: []) // 이미지가 없는 경우, 빈 MultipartFormData를 생성하여 반환
                     return .just(emptyModel)
                } else {
                    let multipartFormData = MultipartFormData() // 이미지가 있는 경우, 이미지 업로드를 진행하여 결과를 반환
                    for data in uploadQuery.files {
                        multipartFormData.append(data!, withName: "files", fileName: "moana\(UUID()).jpg", mimeType: "image/jpg")
                    }
                    return NetworkManager.requestUploadImage(query: multipartFormData).asObservable()
                }
            }
            .map { model in
                uploadedImages.accept(model)
            }
            .withLatestFrom(postObservable)
            .flatMap { images, title, content, content1 in
                let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: ProductID.PostId.rawValue, files: images.files)
                return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
            }
            .subscribe { model in
                saveDone.accept(())
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)

        

//        input.inputSaveButtonTapped
//            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
//                guard let self = self else { return .empty() }
//                let images = self.images.value
//                
//                guard !images.isEmpty else {
//                    let emptyFiles: [Data] = [] // 빈 배열로 초기화
//                    let uploadQuery = UploadPostImageFilesQuery(files: emptyFiles)
//                    return .just(uploadQuery)
//                }
//                return Observable.of(images)
//                    .map { images in
//                        print(images, "이젠 되게찌")
//                        return UploadPostImageFilesQuery(files: images)
//                    }
//            }
//            .map { value in
//                    print(value, "뷰모델에서 확인")
//                    let multipartFormData = MultipartFormData()
//                    for data in value.files {
//                        multipartFormData.append(data!,
//                                                 withName: "files",
//                                                 fileName: "moana\(UUID()).jpg",
//                                                 mimeType: "image/jpg")
//                    }
//                    print(value, "데이터 확인")
//                    return multipartFormData
//            }
//            .flatMap { data in
//                return NetworkManager.requestUploadImage(query: data)
//            }
//            .map { model in
//                uploadedImages.accept(model)
//            }
//            .withLatestFrom(postObservable)
//            .flatMap { images, title, content, content1 in
//                let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: images.files)
//                return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//            }
//            .subscribe { model in
//                print(model, "포스트 등록 성공")
//                saveDone.accept(())
//            } onError: { error in
//                print("포스트 등록 실패")
//            }
//            .disposed(by: disposeBag)
        
//        =======
//                input.inputSaveButtonTapped
//                    .withLatestFrom(postObservable)
//                    .flatMap { images, title, content, content1 in
//                        let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: ProductID.PostId.rawValue, files: images.files)
//                        return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                    }
//                    .subscribe { model in
//                        saveDone.accept(())
//                    } onError: { error in
//                        print(error)
//                    }
//                    .disposed(by: disposeBag)
//        
//        //MARK: Data를 보내기에 힘들었다,,,,
//        input.addPostButtonTapped
//            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
//                    guard let self = self else { return .empty() }
//                    return Observable.of(self.images.value)
//                        .map { images in
//                            return UploadPostImageFilesQuery(files: images)
//                        }
//                }
//            .map { value in
//                print(value, "뷰모델에서 확인")
//                let multipartFormData = MultipartFormData()
//                for data in value.files {
//                    multipartFormData.append(data!, withName: "files", fileName: "moana\(UUID()).jpg", mimeType: "image/jpg")
//                }
//                print(value, "데이터 확인")
//                return multipartFormData
//            }
//            .flatMap { data in
//                return NetworkManager.requestUploadImage(query: data)
//            }
//            .subscribe { model in
//                uploadedImages.accept(model)
//                print(model)
//            } onError: { error in
//                print(error)
//            }
//            .disposed(by: disposeBag)
     

        
        return Output(presentImagePickerView: input.addImageButtonTapped.asDriver(onErrorJustReturn: ()),
                      categoryHalfModal: input.categoryButtonTapped.asDriver(onErrorJustReturn: ()), cancelButtonTapped: input.cancalButtonTapped.asDriver(onErrorJustReturn: ()), 
                      savePost: saveDone.asDriver(onErrorJustReturn: ()))
    }
}
