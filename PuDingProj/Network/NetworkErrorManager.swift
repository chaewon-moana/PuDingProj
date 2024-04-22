//
//  NetworkErrorManager.swift
//  PuDingProj
//
//  Created by cho on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkErrorManager {
    
    static let shared = NetworkErrorManager()
    let disposedBag = DisposeBag()
    
    enum NetworkError: Int, Error {
        case requiredValue = 400
        case notRegistUser = 401 //미가입, 비밀번호 불일치
        case expiredRefreshToken = 418
        case expiredAccessToken = 419
        case alreadyJoinUser = 409
        
        func handleNetworkError(_ code: Int) {
            switch self {
            case .expiredAccessToken:
                NetworkErrorManager.shared.tokenRefresh()
            case .expiredRefreshToken:
                NetworkErrorManager.shared.moveToLoginView()
            case .requiredValue:
                print("query에 필수값이 안들어왔음")
            case .notRegistUser:
                print("가입안한 유저 혹은 비밀번호 틀림")
            case .alreadyJoinUser:
                print("이미 가입한 유저")
            }
        }
    }
    
    private func tokenRefresh() {
        print("액세스토큰만료 확인!")
        let item = NetworkManager.requestNetwork(router: .account(.refresh), modelType: refreshAccessToken.self)
        item
            .subscribe { value in
                UserDefaults.standard.set(value.accessToken, forKey: "accessToken")
            } onFailure: { error in
                print("accessToken refresh하는데서 에러남")
            }
            .disposed(by: disposedBag)
    }
    
    private func moveToLoginView() {
        print("리프레시토큰만료 확인!")
    }
}

