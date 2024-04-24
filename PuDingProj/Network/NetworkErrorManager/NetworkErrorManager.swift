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
        case forbidden = 403 //접근권한이 없음
        case alreadyJoinUser = 409 //이메일 중복확인 시 리턴
        case noPostCreated = 410 //생성된 게시글이 없음
        case expiredRefreshToken = 418
        case expiredAccessToken = 419
        case overcell = 429 //과호출
        case invalidURL = 444 //비정상적 URL
        case notPermissionEdit = 445 //수정권한 없음, 본인 게시글만 수정 가능
        case serverError = 500 //비정상 요청 및 정의되지 않은 에러
       
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
            case .invalidURL:
                print("유효하지 않은 URL")
            case .serverError:
                print("서버에러")
            case .overcell:
                print("과호출")
            case .forbidden:
                print("접근권한 없음")
            case .noPostCreated:
                print("생성된 포스트가 없음")
            case .notPermissionEdit:
                print("본인 게시글만 수정 및 삭제 가능")
            }
        }
    }
    
    private func tokenRefresh() {
        print("액세스토큰만료 확인!")
        let item = NetworkManager.requestNetwork(router: .account(.refresh), modelType: refreshAccessToken.self)
        item
            .subscribe { value in
                UserDefault.accessToken = value.accessToken
            } onFailure: { error in
                print("accessToken refresh하는데서 에러남")
            }
            .disposed(by: disposedBag)
    }
    
    private func moveToLoginView() {
        print("리프레시토큰만료 확인!")
        //TODO: loginView로 이동
    }
}

