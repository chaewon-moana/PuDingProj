//
//  PaymentRouter.swift
//  PuDingProj
//
//  Created by cho on 5/9/24.
//

import Foundation
import Alamofire

enum PaymentRouter {
    case validation(query: PaymentValidationQuery)
    case paymentList
}

extension PaymentRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation:
            return .post
        case .paymentList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .validation:
            return "payments/validation"
        case .paymentList:
            return "payments/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .validation:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .paymentList:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .validation(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .paymentList:
            return nil
        }
    }
}
