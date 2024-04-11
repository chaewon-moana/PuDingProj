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
                let urlRequest = try Router.join(query: query).asURLRequest()
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
}
