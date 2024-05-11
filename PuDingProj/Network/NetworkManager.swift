//
//  NetworkManager.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkManager {
    //MARK: Query - query, Model - Model
    static func requestNetwork<Model: Decodable>(router: Router, modelType: Model.Type) -> Single<Model> {
        return Single<Model>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: Model.self) { response in
                        print(response)
                        switch response.result {
                        case .success(let value):
                            print("router 서엉고옹")
                            single(.success(value))
                        case .failure(let error):
                            print(response.response?.statusCode)
                            guard let code = response.response?.statusCode else { return }
                            if let networkError = NetworkErrorManager.NetworkError(rawValue: code) {
                                networkError.handleNetworkError(code)
                            } else {
                                print("NetWorkError 처리 못하는 에러어발생")
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                print("안돼안돼!")
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func requestDeletePost(router: Router) {
        do {
            let urlRequest = try router.asURLRequest()
            AF.request(urlRequest).response { response in
                switch response.result {
                case .success(let value):
                    print(value, "delete 성공")
                case .failure(let error):
                    print(error, "delete 실패")
                }
            }
        } catch {
            print("catch error")
        }
    }
    static func requestDeleteComment(postID: String, commentID: String) {
        do {
            let urlRequest = try Router.comment(.deleteComment(postID: postID, commentID: commentID)).asURLRequest()
            AF.request(urlRequest).response { response in
                switch response.result {
                case .success(let value):
                    print(value, "delete 성공")
                case .failure(let error):
                    print(error, "delete 실패")
                }
            }
        } catch {
            print("catch error")
        }
    }
    
   
  
    
//    static func requestPostText() -> Single<inqueryUppperPostModel> {
//            return Single<inqueryUppperPostModel>.create { single in
//                do {
//                    let urlRequest = try PostRouter.inqueryPost.asURLRequest()
//                    AF.request(urlRequest)
//                        .validate(statusCode: 200..<300)
//                        .responseDecodable(of: inqueryUppperPostModel.self) { response in
//                            switch response.result {
//                            case .success(let value):
//                                print(value, "포스트 조회 성공 ------")
//                                single(.success(value))
//                            case .failure(let error):
//                                print(response.response?.statusCode, #function, "실패애", error)
//                                single(.failure(error))
//                            }
//                        }
//                } catch {
//                    single(.failure(error))
//                }
//                return Disposables.create()
//            }
//        }

    static func requestUploadImage(query: MultipartFormData) -> Single<UploadPostImageFilesModel> {
           return Single<UploadPostImageFilesModel>.create { single in
               do {
                   let urlRequest = try PostRouter.uploadImage.asURLRequest()
                   AF.upload(multipartFormData: query, to: urlRequest.url!, headers: urlRequest.headers)
                       .validate(statusCode: 200..<300)
                       .responseDecodable(of: UploadPostImageFilesModel.self) { response in
                           print(response, "이미지 올린것 확인")
                           switch response.result {
                           case .success(let value):
                               print(value, "이미지 올린것222 성공")
                               single(.success(value))
                           case .failure(let error):
                               print(response.response?.statusCode, "이미지 올린 것333 실패")
                               single(.failure(error))
                           }
                       }
               } catch {
                   single(.failure(error))
               }
               return Disposables.create()
           }
       }
    
    static func editProfile(query: MultipartFormData) -> Single<InqueryProfileModel> {
           return Single<InqueryProfileModel>.create { single in
               do {
                   let urlRequest = try ProfileRouter.editProfile.asURLRequest()
                   print(urlRequest.url)
                   AF.upload(multipartFormData: query, to: urlRequest.url!, method: .put, headers: urlRequest.headers)
                       .validate(statusCode: 200..<300)
                       .responseDecodable(of: InqueryProfileModel.self) { response in
                           print(response, "프로필 수정 확인")
                           switch response.result {
                           case .success(let value):
                               print(value, "프로필 수정 수정 성공")
                               single(.success(value))
                           case .failure(let error):
                               print(response.response?.statusCode, "프로필 올린 것333 실패")
                               single(.failure(error))
                           }
                       }
               } catch {
                   single(.failure(error))
               }
               return Disposables.create()
           }
       }
}
//    static func checkEmailValidation(email: emailQuery) -> Single<emailValidationModel> {
//        return Single<emailValidationModel>.create { single in
//            do {
//                let urlRequest = try Router.emailValidation(email: email).asURLRequest()
//                AF.request(urlRequest)
//                    .validate(statusCode: 200..<300)
//                    .responseDecodable(of: emailValidationModel.self) { response in
//                        print(response, "이메일중복확인")
//                        switch response.result {
//                        case .success(let value):
//                            print(value, "이메일중복확인 성공")
//                            single(.success(value))
//                        case .failure(let error):
//                            print(response.response?.statusCode)
//                            single(.failure(error))
//                        }
//                    }
//            } catch {
//                single(.failure(error))
//            }
//            return Disposables.create()
//        }
//    }
