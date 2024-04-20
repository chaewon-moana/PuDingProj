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
    //let imageList = BehaviorRelay<[Data?]>(value: [])
    var images: BehaviorRelay<[Data?]> = BehaviorRelay(value: [])
    
    struct Input {
        let titleText: Observable<String>
        let contentText: Observable<String>
        let addPostButtonTapped: Observable<Void>
        let addImageButtonTapped: Observable<Void>
        let imageList: BehaviorRelay<[Data?]>
    }
    
    struct Output {
        let presentImagePickerView: Driver<Void>
    }
    
    func updateImageList(value: [Data?]) {
        images.accept(value)
        print(images, "asdfasdf")
    }
    
    func transform(input: Input) -> Output {
        //let image = (ImageFileManager.shared.loadImageFromDocument(fileName: "임시테스트.jpg")?.jpegData(compressionQuality: 0.5))
        
        let textObservable = Observable.combineLatest(input.titleText, input.contentText)
            .map { title, content in
                //TODO: content1 -> 게시글 분류값
                return RegisterPostQuery(title: title, content: content, content1: "후원모집", product_id: "puding-moana22")
            }
        
        let imageObservable = Observable.of(images.value)
            .map { image in
                print(image, "ㅁㄴㅇㄹㅁㄴㅇㄹ")
                return UploadPostImageFilesQuery(files: image)
            }
        
        //MARK: Data를 보내기에 힘들었다,,,,
        input.addPostButtonTapped
            .flatMap { [weak self] _ -> Observable<UploadPostImageFilesQuery> in
                    guard let self = self else { return .empty() }
                    return Observable.of(self.images.value)
                        .map { images in
                            print(images, "이젠 되게찌")
                            return UploadPostImageFilesQuery(files: images)
                        }
                }
            //.withLatestFrom(imageObservable)
            .map { value in
                print(value, "뷰모델에서 확인")
                print(input.imageList.value)
                var multipartFormData = MultipartFormData()
                for data in value.files {
                    multipartFormData.append(data!,
                                             withName: "files",
                                             fileName: "임시moana\(UUID()).jpg",
                                             mimeType: "image/jpg")
                }
                print(value, "데이터 확인")
                return multipartFormData
            }
            .flatMap { data in
                return NetworkManager.requestUploadImage(query: data)
            }
            .subscribe { model in
                print(model)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
     
//        input.addPostButtonTapped
//            .withLatestFrom(imageObservable)
//            .map { value in
//                print(value, "뷰모델에서 확인")
//                print(input.imageList.value)
//                var multipartFormData = MultipartFormData()
//                for data in value.files {
//                    multipartFormData.append(data!,
//                                             withName: "files",
//                                             fileName: "임시moana\(Date())",
//                                             mimeType: "image/jpg")
//                }
//                print(value, "데이터 확인")
//                return multipartFormData
//            }
//            .flatMap { data in
//                return NetworkManager.requestUploadImage(query: data)
//            }
//            .subscribe { model in
//                print(model)
//            } onError: { error in
//                print(error)
//            }
//            .disposed(by: disposeBag)
        
//        input.addPostButtonTapped
//            .withLatestFrom(imageObservable)
//            .flatMap { query in
//                return NetworkManager.requestUploadImage(query: query)
//            }
//            .subscribe { model in
//                print("이미지 저장하는거 성공!", model)
//            } onError: { error in
//                print("이미지 저장하는거 실패", error)
//            }
//            .disposed(by: disposeBag)

        
//        input.addPostButtonTapped
//            .subscribe(with: self) { owner, _ in
//                
//                AF.upload(multipartFormData: { multifartFormData in
//                    //TODO: image 옵셔널 처리하기
//                    multifartFormData.append(image!,
//                                             withName: "files",
//                                             fileName: "임시테스트.jpg",
//                                             mimeType: "image/jpg")
//                }, to: <#T##any URLConvertible#>)
//            }
//            .disposed(by: disposeBag)

//        input.addPostButtonTapped
//            .withLatestFrom(textObservable)
//            .flatMap { query in
//                print("버튼 눌림")
//                return NetworkManager.requestPostNetwork(router: PostRouter.registerPost(query: query), modelType: RegisterPostModel.self)
//            }
//            .subscribe { model in
//                print(model, "포스트 등록 성공")
//            } onError: { error in
//                print(error, "포스트 등록 실패")
//            }
//            .disposed(by: disposeBag)
        
        
        

        return Output(presentImagePickerView: input.addImageButtonTapped.asDriver(onErrorJustReturn: ()))
    }
    

}
