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
    static func joinMember(query: JoinQuery) -> Single<JoinModel> {
        return Single<JoinModel>.create { single in
            do {
                let urlRequest = try AccountRouter.join(query: query).asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: JoinModel.self) { response in
                        print(response)
                        switch response.result {
                        case .success(let value):
                            print(value, "서엉고옹")
                            single(.success(value))
                        case .failure(let error):
                            print(response.response?.statusCode)
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
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
    
    //MARK: Query - query, Model - Model
    static func requestNetwork<Model: Decodable>(router: AccountRouter, modelType: Model.Type) -> Single<Model> {
        return Single<Model>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: Model.self) { response in
                        print(response)
                        switch response.result {
                        case .success(let value):
                            print(value, "router 서엉고옹")
                            single(.success(value))
                        case .failure(let error):
                            print(response.response?.statusCode, "router 에러발생")
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func requestPostText() -> Single<inqueryUppperPostModel> {
            return Single<inqueryUppperPostModel>.create { single in
                do {
                    let urlRequest = try PostRouter.inqueryPost.asURLRequest()
                    print(urlRequest)
                    AF.request(urlRequest)
                        .validate(statusCode: 200..<300)
                        .responseDecodable(of: inqueryUppperPostModel.self) { response in
                            switch response.result {
                            case .success(let value):
                                print(value, "포스트 조회 성공 ------")
                                single(.success(value))
                            case .failure(let error):
                                print(response.response?.statusCode, #function, "실패애", error)
                                single(.failure(error))
                            }
                        }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
        }

    static func requestPostNetwork<Model: Decodable>(router: PostRouter, modelType: Model.Type) -> Single<Model> {
        return Single<Model>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: Model.self) { response in
                        print(response)
                        switch response.result {
                        case .success(let value):
                            print(value, "router 서엉고옹")
                            single(.success(value))
                        case .failure(let error):
                            print(response.response?.statusCode, "router - post - 에러발생")
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    static func requestUploadImage(query: MultipartFormData) -> Single<UploadPostImageFilesModel> {
           return Single<UploadPostImageFilesModel>.create { single in
               do {
                   let urlRequest = try PostRouter.uploadImage.asURLRequest()
                   print("됐,,나,,?")
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
    
//    static func requestUploadImage(query: UploadPostImageFilesQuery) -> Single<UploadPostImageFilesModel> {
//           return Single<UploadPostImageFilesModel>.create { single in
//               do {
//                   let urlRequest = try PostRouter.uploadImage(query: query).asURLRequest()
//                   print("됐,,나,,?")
//                   AF.upload(multipartFormData: { multipartFormData in
//                       multipartFormData.append(query.files[0],
//                                                withName: "files",
//                                                fileName: "임시테스트dddd.jpg",
//                                                mimeType: "image/jpg")
//                   }, to: urlRequest.url!, headers: urlRequest.headers)
//                       .validate(statusCode: 200..<300)
//                       .responseDecodable(of: UploadPostImageFilesModel.self) { response in
//                           print(response, "이미지 올린것 확인")
//                           switch response.result {
//                           case .success(let value):
//                               print(value, "이미지 올린것222 성공")
//                               single(.success(value))
//                           case .failure(let error):
//                               print(response.response?.statusCode, "이미지 올린 것333 실패")
//                               single(.failure(error))
//                           }
//                       }
//               } catch {
//                   single(.failure(error))
//               }
//               return Disposables.create()
//           }
//       }
    
    
//    static func loginUser(query: LoginQuery) -> Single<LoginModel> {
//        return Single<LoginModel>.create { single in
//            do {
//                let urlRequest = try Router.login(query: query).asURLRequest()
//                AF.request(urlRequest)
//                    .validate(statusCode: 200..<300)
//                    .responseDecodable(of: LoginModel.self) { response in
//                        print(response, "로그인 확인")
//                        switch response.result {
//                        case .success(let value):
//                            print(value, "로그인 성공")
//                            single(.success(value))
//                        case .failure(let error):
//                            print(response.response?.statusCode, "로그인 실패")
//                            single(.failure(error))
//                        }
//                    }
//            } catch {
//                single(.failure(error))
//            }
//            return Disposables.create()
//        }
//    }
    
   
}



