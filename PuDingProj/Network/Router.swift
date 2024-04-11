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
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .join:
            return "users/join"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .join:
            return [ HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                     HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        switch self {
        case .join:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .join:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .join(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
    
    
}
