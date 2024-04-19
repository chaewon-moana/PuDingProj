//
//  PostRouter.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case registerPost(query: RegisterPostQuery)
    case inqueryPost
}

enum PostModel {
    case registerPost(model: RegisterPostModel)
}

extension PostRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .registerPost:
            return .post
        case .inqueryPost:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .registerPost:
            return "posts"
        case .inqueryPost:
            return "posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .registerPost:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken")!,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .inqueryPost:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken")!,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .registerPost:
            return nil
        case .inqueryPost:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .registerPost:
            return nil
        case .inqueryPost:
            return [URLQueryItem(name: "product_id", value: "puding-moana22")]
        }
    }
    
    var body: Data? {
        switch self {
        case .registerPost(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .inqueryPost:
            return nil
        }
    }
}
