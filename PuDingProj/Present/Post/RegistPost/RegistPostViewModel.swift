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
    var tmp: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
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
        tmp.accept(value.count)
        images.accept(value)
        print(images, "falg", images.value.count)
        print("tmp를 찾아라!!!!!", tmp.value)
    }
    
    func transform(input: Input) -> Output {
        let emptyImage = BehaviorRelay<[String]>(value: [])
        let uploadedImages = PublishRelay<UploadPostImageFilesModel>()
        let uploadImageList = PublishRelay<[String]>()
        let postObservable = Observable.combineLatest(uploadImageList, input.titleText, input.contentText, input.postData)
        let textPostObservable = Observable.combineLatest(emptyImage, input.titleText, input.contentText, input.postData)
        let imageObservable = images.value
        
        let saveDone = PublishRelay<Void>()
        let content1 = PublishRelay<String>()
   
        input.inputTrigger
            .subscribe(with: self) { owner, _ in
                owner.tmp.accept(0)
                print("tmp를 찾아라", owner.tmp.value)
            }
            .disposed(by: disposeBag)
        
        tmp.subscribe(onNext: { value in
            if value == 0 {
                print("tmp를 찾아라!123", value)
                input.inputSaveButtonTapped
                    .withLatestFrom(textPostObservable)
                    .flatMap { images, title, content, content1 in
                        let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: [])
                        return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
                    }
                    .subscribe { model in
                        print(model, "포스트 등록 성공")
                        saveDone.accept(())
                    } onError: { error in
                        print("포스트 등록 실패")
                    }
                    .disposed(by: self.disposeBag)
            } else {
                print("tmp를 찾아라!3333", value)
                input.inputSaveButtonTapped
                    .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
                        guard let self = self else { return .empty() }
                        return Observable.of(images.value)
                            .map { images in
                                print(images, "이젠 되게찌")
                                return UploadPostImageFilesQuery(files: images)
                            }
                    }
                    .map { value in
                        print(value, "뷰모델에서 확인88888")
                        let multipartFormData = MultipartFormData()
                        for data in value.files {
                            multipartFormData.append(data!,
                                                     withName: "files",
                                                     fileName: "moana\(UUID()).jpg",
                                                     mimeType: "image/jpg")
                        }
                        print(value, "데이터 확인88888")
                        return multipartFormData
                    }
                    .flatMap { data in
                        print(888881)
                        return NetworkManager.requestUploadImage(query: data)
                    }
                    .flatMap { model in
                        print(888882)
                        uploadImageList.accept(model.files)
                        return Observable.combineLatest(Observable.just(model.files), input.titleText, input.contentText, input.postData)
                    }
                    .flatMap { files, title, content, content1 in
                        print("넌 된 228888", files)//,  files, title, content, content1)
                        let query = RegisterPostQuery(title: "sdf", content: "sdf", content1: "sdf", product_id: "puding-moana22", files: files)
                        return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
                    }

//                    .flatMap { data in
//                        print(888881)
//                        return NetworkManager.requestUploadImage(query: data)
//                    }
//                    .map { model in
//                        print(888882)
//                        uploadImageList.accept(model.files)
//                        return model.files
//                    }
//                    .flatMap { model in
//                        print(postObservable)
//                        return postObservable
//                    }
//                  //  .withLatestFrom(postObservable)
//                    .flatMap { files, title, content, content1 in
//                        print("넌 된 228888", files)//,  files, title, content, content1)
//                        let query = RegisterPostQuery(title: "sdf", content: "sdf", content1: "sdf", product_id: "puding-moana22", files: files)
//                        return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                    }
//                    .withLatestFrom(postObservable)
//                    .flatMap { images, title, content, content1 in
//                        print(images, title, content, content1, "쓰애애앱88888")
//                        let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: images.files)
//                        return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                    }
                    .subscribe { model in
                        print(model, "포스트 등록 성공")
                        saveDone.accept(())
                    } onError: { error in
                        print("포스트 등록 실패")
                    }
                    .disposed(by: self.disposeBag)
            }
        })
        .disposed(by: disposeBag)

        
//        if tmp.value == 0 {
//            print("tmp를 찾아라!123", tmp)
//            input.inputSaveButtonTapped
//                .withLatestFrom(textPostObservable)
//                .flatMap { images, title, content, content1 in
//                    let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: [])
//                    return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                }
//                .subscribe { model in
//                    print(model, "포스트 등록 성공")
//                    saveDone.accept(())
//                } onError: { error in
//                    print("포스트 등록 실패")
//                }
//                .disposed(by: disposeBag)
//        } else {
//            print("tmp를 찾아라!3333", tmp)
//            input.inputSaveButtonTapped
//                .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
//                    guard let self = self else { return .empty() }
//                    return Observable.of(images.value)
//                        .map { images in
//                            print(images, "이젠 되게찌")
//                            return UploadPostImageFilesQuery(files: images)
//                        }
//                }
//                .map { value in
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
//                }
//                .flatMap { data in
//                    return NetworkManager.requestUploadImage(query: data)
//                }
//                .map { model in
//                    uploadedImages.accept(model)
//                }
//                .withLatestFrom(postObservable)
//                .flatMap { images, title, content, content1 in
//                    print(images, title, content, content1, "쓰애애앱")
//                    let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: images.files)
//                    return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                }
//                .subscribe { model in
//                    print(model, "포스트 등록 성공")
//                    saveDone.accept(())
//                } onError: { error in
//                    print("포스트 등록 실패")
//                }
//                .disposed(by: disposeBag)
//        }
//
//                input.inputSaveButtonTapped
//                    .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
//                        guard let self = self else { return .empty() }
//                        return Observable.of(self.images.value)
//                            .map { images in
//                                print(images, "이젠 되게찌")
//                                return UploadPostImageFilesQuery(files: images)
//                            }
//                    }
//                    .map { value in
//                            print(value, "뷰모델에서 확인")
//                            let multipartFormData = MultipartFormData()
//                            for data in value.files {
//                                multipartFormData.append(data!,
//                                                         withName: "files",
//                                                         fileName: "moana\(UUID()).jpg",
//                                                         mimeType: "image/jpg")
//                            }
//                            print(value, "데이터 확인")
//                            return multipartFormData
//                    }
//                    .flatMap { data in
//                        return NetworkManager.requestUploadImage(query: data)
//                    }
//                    .map { model in
//                        uploadedImages.accept(model)
//                    }
//                    .withLatestFrom(postObservable)
//                    .flatMap { images, title, content, content1 in
//                        let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: images.files)
//                        return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                    }
//                    .subscribe { model in
//                        print(model, "포스트 등록 성공")
//                        saveDone.accept(())
//                    } onError: { error in
//                        print("포스트 등록 실패")
//                    }
//                    .disposed(by: disposeBag)
//        
//        input.inputSaveButtonTapped
//            .flatMap { [weak self] _ -> Observable<RegisterPostModel> in
//                guard let self = self else { return .empty() }
//                let images = self.images.value
//                if images.isEmpty {
//                    print("되곤 있는걸까")
//                    return Observable.of([])
//                        .withLatestFrom(textPostObservable)
//                        .flatMap { image, title, content, content1 in
//                            print(title, content, content1)
//                            let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: [])
//                            return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                        }
//                } else {
//                    return Observable.of(images)
//                        .map { UploadPostImageFilesQuery(files: $0) }
//                        .map { value in
//                            print(value, "뷰모델에서 확인")
//                            let multipartFormData = MultipartFormData()
//                            for data in value.files {
//                                multipartFormData.append(data!,
//                                                         withName: "files",
//                                                         fileName: "moana\(UUID()).jpg",
//                                                         mimeType: "image/jpg")
//                            }
//                            print(value, "데이터 확인")
//                            return multipartFormData
//                        }
//                        .flatMap { data in
//                            //print(11111111)
//                           NetworkManager.requestUploadImage(query: data)
//                            
//                        }
//                        .map { model in
//                            uploadedImages.accept(model)
//                            print(222222222222)
//                        }
//                        .withLatestFrom(postObservable)
//                        .flatMap { images, title, content, content1 in
//                            print(333333)
//                            let query = RegisterPostQuery(title: title, content: content, content1: content1, product_id: "puding-moana22", files: images.files)
//                            return NetworkManager.requestNetwork(router: .post(.registerPost(query: query)), modelType: RegisterPostModel.self)
//                        }
//                }
//            }
//            .subscribe { model in
//                print(model, "포스트 등록 성공")
//                saveDone.accept(())
//            } onError: { error in
//                print("포스트 등록 실패")
//            }
//            .disposed(by: disposeBag)

       


//        input.inputSaveButtonTapped
//            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
//                guard let self = self else { return .empty() }
//                return Observable.of(self.images.value)
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
////        
//        =======
        
        
        //        input.inputSaveButtonTapped
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
        
        //MARK: Data를 보내기에 힘들었다,,,,
//        input.addPostButtonTapped
//            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
//                    guard let self = self else { return .empty() }
//                    return Observable.of(self.images.value)
//                        .map { images in
//                            print(images, "이젠 되게찌", content1)
//                            return UploadPostImageFilesQuery(files: images)
//                        }
//                }
//            .map { value in
//                print(value, "뷰모델에서 확인")
//                let multipartFormData = MultipartFormData()
//                for data in value.files {
//                    multipartFormData.append(data!,
//                                             withName: "files",
//                                             fileName: "moana\(UUID()).jpg",
//                                             mimeType: "image/jpg")
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
