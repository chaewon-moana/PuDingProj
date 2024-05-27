//
//  TokenManager.swift
//  PuDingProj
//
//  Created by cho on 5/12/24.
//

import Foundation
import Alamofire
import RxSwift

final class TokenManager: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        let accessToken = UserDefault.accessToken
        if !accessToken.isEmpty {
            urlRequest.setValue(accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        NetworkManager.requestNetwork(router: .account(.refresh), modelType: RefreshTokenModel.self)
            .subscribe { model in
                UserDefault.accessToken = model.accessToken
                completion(.retry)
            } onFailure: { error in
                completion(.doNotRetryWithError(error))
            }
            .disposed(by: disposeBag)
    }
}
