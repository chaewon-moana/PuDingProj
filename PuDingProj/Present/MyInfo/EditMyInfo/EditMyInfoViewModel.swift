//
//  EditMyInfoViewModel.swift
//  PuDingProj
//
//  Created by cho on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class EditMyInfoViewModel {

    let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: Observable<Void>
        let editImageButtonTapped: Observable<Void>
        let editImageResult: Observable<(String, String, Data?)>
        let editDoneButtonTapped: Observable<Void>
    }
    
    struct Output {
        let inputTrigger: Observable<Void>
        let editImageButtonTapped: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let imageObservable = PublishRelay<Data?>()
        
        let query = input.editImageResult
            .map { nick, phone, image in
                let multipartData = MultipartFormData()
                multipartData.append(nick.data(using: .utf8)!, withName: "nick")
                multipartData.append(phone.data(using: .utf8)!, withName: "phoneNum")
                multipartData.append(image!, withName: "profile", fileName: "moana\(UUID()).jpg", mimeType: "image/jpg")
                return multipartData
            }
        
        input.editDoneButtonTapped
            .withLatestFrom(query)
            .flatMap { query in
                print(query, "뭐가 없다는거느뇽")
                return NetworkManager.editProfile(query: query)
//                return NetworkManager.requestNetwork(router: .profile(.editProfile(query: query)), modelType: InqueryProfileModel.self)
            }
            .subscribe { model in
                print(model, "프로필 수정 성공")
            } onError: { error in
                print(error, "프로필 수정 에러 발생")
            }
            .disposed(by: disposeBag)
        
//            .map { value in
//                print(value, "뷰모델에서 확인")
//                print(input.imageList.value)
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

        
//        input.editDoneButtonTapped
//            .withLatestFrom(imageObservable)
//            .map { data in
//                let multipartFormData = MultipartFormData()
//                    multipartFormData.append(data!,
//                                             withName: "files",
//                                             fileName: "moana\(UUID()).jpg",
//                                             mimeType: "image/jpg")
//                return multipartFormData
//            }
//            .flatMap { data in
//                return NetworkManager.requestUploadImage(query: data)
//            }
//            .subscribe { model in
//                print("업로드 서엉고옹")
//            } onError: { error in
//                print(error, "하 실패")
//            }
//            .disposed(by: disposeBag)
//
//        
        
    


        
        
        
        return Output(inputTrigger: input.inputTrigger,
                      editImageButtonTapped: input.editImageButtonTapped)
    }
}

