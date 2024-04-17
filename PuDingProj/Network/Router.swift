//
//  Router.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation
import Alamofire

enum Router {
    case join(query: JoinQuery)
    case emailValidation(email: emailQuery)
    case login(query: LoginQuery)
}

enum Model {
    case join(model: JoinModel)
    case login(model: LoginModel)
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
            return .post
        case .emailValidation:
            return .post
        case .login:
            return .post
            
        }
    }
    
    var path: String {
        switch self {
        case .join:
            return "users/join"
        case .emailValidation:
            return "validation/email"
        case .login:
            return "users/login"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .join:
            return [ HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                     HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .emailValidation:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .login:
            return [ HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                     HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .join:
            return nil
        case .emailValidation:
            return nil
        case .login:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .join:
            return nil
        case .emailValidation:
            return nil
        case .login:
            return nil
        }
    }
    
    //TODO: 동작원리 좀 더 공부하기
    var body: Data? {
        switch self {
        case .join(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .emailValidation(let email):
            let encoder = JSONEncoder()
            return try? encoder.encode(email)
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
    
    
}
