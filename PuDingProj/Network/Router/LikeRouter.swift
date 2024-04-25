//
//  LikeRouter.swift
//  PuDingProj
//
//  Created by cho on 4/24/24.
//

import Foundation
import Alamofire

enum LikeRouter {
    case like(query: LikeQuery, id: String)
    case inquery
}

extension LikeRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .like:
            return .post
        case .inquery:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .like(_, let id):
            return "posts/\(id)/like"
        case .inquery:
            return "posts/likes/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .like:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .inquery:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
       return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .like:
            return nil
            //TODO: next와 limit 판단해서 로직 구현
        case .inquery:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .like(let query, _):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .inquery:
            return nil
        }
    }
    
    
}
