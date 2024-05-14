# Puding ReadMe

# 앱 소개

<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/2b264d11-e4e7-4875-a73b-099ba6ed829d" width="200" height="200"/>

- 앱 한줄 소개
    - 유기견 보호소 관련 커뮤니티 앱

- 개발 환경
    - 1인 개발(기획, 디자인, 개발)
    - iOS 16.0+, 라이트모드, 세로모드
    - 24.04.12 ~ 24.05.05 (약 3주)
    

## 주요 기능

1. 커뮤니티 포스트 / 포스트 작성
    - 키워드 검색 기능
    - 다른 유저가 올린 포스트 확인
    - 카테고리에 따른 포스트 작성
2. 펀딩 뷰 / 펀딩 작성 / 포트원을 통한 결제
    - 필요한 물품 펀딩 포스트 작성
    - 후원하고 싶은 물품 직접 후원
    - 포트원을 이용한 결제 기능
3. 마이 인포
    - 작성한 post 조회
    - 후원한 총 금액 확인
    - 프로필 수정
    - 탈퇴 기능

## 기술 스택

- UIKit, SnapKit, Then, CodeBaseUI, CustomUI, BaseView
- MVVM, Input-Output Pattern, RxSwift, RxCocoa
- UserDefaults, Codable, Router Pattern
- Alamofire, Kingfisher, PhotoUI, Toast, TextFieldEffects
- iamport-ios

## 구현 기술

- 열거형과 PropertyWrapper를 이용해 UserDefaults 관리
- Alamofire의 RequestIntercepter를 이용한 JWT 토큰 갱신
- 제네릭을 활용해 네트워크 통신 메서드 구현
- contentOffset을 이용한 페이지네이션 구현
- 열거형을 통한 HTTP StatusCode 에러 핸들링
- 접근 제어자와 final 키워드를 활용해 성능 최적화


# 앱 화면


### 회원가입 및 로그인

<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/17a2bdab-6cca-44be-a7b2-f1f3301e8d1d" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/62ab3a4d-baa0-427a-adbe-75f8ae3c9faf" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/df5ce297-066c-4662-8f84-8fcea6c3ce07" width="30%" height="30%">

- 회원가입, 로그인, 이메일 중복 확인 API
- Toast 라이브러리
- UserDefaults로 이메일 저장 기능 구현
![Simulator Screen Recording - iPhone 15 - 17 4 - 2024-05-12 at 17 16 10](https://github.com/chaewon-moana/PuDingProj/assets/127464395/213244d6-0d62-4ada-9660-010ae8a87443)

### 커뮤니티 포스트
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/3ad1c6b4-ef17-4c53-82fb-cf5d71b98ccf" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/a01fb5b1-4372-492e-8cfc-f3e13d446928" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/6243795c-a9a8-4bc4-b1ce-415efe5ce7c7" width="30%" height="30%">

- 포스트 확인, 댓글 작성, 삭제 기능
- contentOff 기반의 페이지네이션 구현

### 포스트 작성

<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/0023f2c7-c9c5-418f-a854-a6bdefc78248" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/e01f7e1c-d02f-4f91-b8ca-312b5249f86c" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/d4b1199f-aca8-4a6f-a127-a1040147c80b" width="30%" height="30%">


- 카테고리 분류별로 포스트 작성
- 사진 5장까지 추가 가능

### 펀딩 화면 및 포트원 결제
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/b0fe3836-598e-4c78-995a-488ab7bf9e90" width="20%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/8b92e539-ce5a-480c-a113-1e2f6802082b" width="20%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/81f96c95-6f39-48ef-9bdf-4a14f66174f9" width="20%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/02ef6309-1204-4473-b08d-136e73c57a0d" width="20%" height="30%">

- 포트원 결제 활용

### 내 정보

<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/544a2c5f-d713-4d7a-9acb-2966859d79f2" width="30%" height="30%">

- 개인 정보 수정 및 My Post 확인
- 총 후원금액 확인 가능

# 트러블 슈팅

## contentOffset 기반 Pagination
<img width="700" alt="Untitled" src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/99b47c0c-b9f2-49f0-916c-9f59de650ce7">
<img width="700" alt="Untitled 1" src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/f83e6af7-859a-4dc6-acb9-4408dc8347c4">

- 문제 상황 : contentOffset 기반이라 다음 post들이 호출되기 전 여러 번 fetchNextPage 메서드가 호출되는 문제 발생했습니다.
- 해결방안 : isLoading이라는 변수를 두어, 호출되기 전에 true로 값을 지정, 호출되는 동안 false로 두어 여러 번 호출되는 것을 방지했습니다.

### Enum과 제네릭으로 Router 및 메서드 관리
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/b8eb2bbb-7433-462e-9bfa-5df1e5f6b24c" width="30%" height="30%">
<img src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/83fee7ec-df0f-409f-997c-b2971d689f28" width="30%" height="40%">

```swift
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
                            single(.success(value))
                        case .failure(let error):
                            guard let code = response.response?.statusCode else { return }
                            if let networkError = NetworkErrorManager.NetworkError(rawValue: code) {
                                networkError.handleNetworkError(code)
                            } else {
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
```

- 문제 상황 : 서버에 요청하는 메서드가 너무 많아, 코드가 길어지도 중복 코드가 많았습니다.
- 해결방안 : 열거형으로 Router를 관리하며 코드 가독성을 높이고 유지보수에 용이하도록 구현하였습니다. 또, 제네릭을 이용해 서버에 요쳥하는 메서드를 구현해 코드 재사용성을 높였습니다.

### Property Wrapper를 이용한 UserDefaults 관리
<img width="629" alt="Untitled 4" src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/ddb8b894-e8fd-4aa1-a4ae-325654a2fcd0">

열거형과 property wrapper를 활용해 UserDefaults를 관리하였습니다. 

### CustomUI 활용
<img width="364" alt="Untitled 5" src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/e1ac545c-4c63-415e-b76c-d7ea41d981b0">

자주 쓰이는 화면은 CustomView로 만들어 유지보수가 쉽도록 하였고, 코드 가독성을 높였습니다.

### HTTP StatusCode 및 Token 관리

<img width="600" alt="Untitled 7" src="https://github.com/chaewon-moana/PuDingProj/assets/127464395/9e31b53f-d4cf-4ebd-b48e-fe82d57fbf59">

```swift
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
        guard let window = UIApplication.shared.windows.first,
              let rootViewController = window.rootViewController else { return }
        let loginViewController = LoginViewController()
        if let navigationController = rootViewController as? UINavigationController {
               navigationController.pushViewController(loginViewController, animated: true)
        } else {
               let navigationController = UINavigationController(rootViewController: loginViewController)
               window.rootViewController = navigationController
               window.makeKeyAndVisible()
           }
    }
```

열거형으로 HTTP StatusCode 관리 및 Token 갱신을 구현했습니다.

accessToken이 만료되면 refreshToken을 확인 후 갱신 작업을 해주었습니다.

refreshToken이 만료되면 LoginViewController로 이동해, 다시 로그인하도록 유도했습니다.