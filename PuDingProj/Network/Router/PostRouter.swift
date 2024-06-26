//
//  PostRouter.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation
import Alamofire

enum PostRouter {
    //query -> body로 변경,,ㅠ query1을 query로 두기
    case registerPost(query: RegisterPostQuery)
    case registerFunding(query: RegisterFundungQuery)
    case inqueryPost(next: String, productId: String)
    case uploadImage
    case inquerySpecificPost(id: String)
    case editPost(query: EditPostQuery, id: String)
    case deletePost(id: String)
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
        case .uploadImage:
            return .post
        case .inquerySpecificPost:
            return .get
        case .editPost:
            return .put
        case .deletePost:
            return .delete
        case .registerFunding:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .registerPost:
            return "posts"
        case .inqueryPost:
            return "posts"
        case .uploadImage:
            return "posts/files"
        case .inquerySpecificPost(let id):
            return "posts/\(id)"
        case .editPost(let query, let id):
            return "posts/\(id)"
        case .deletePost(let id):
            return "posts/\(id)"
        case .registerFunding(query: let query):
            return "posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .registerPost:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .inqueryPost:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .uploadImage:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .inquerySpecificPost:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .editPost:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .deletePost:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .registerFunding(query: let query):
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .registerPost:
            return nil
        case .inqueryPost(let next, let productId):
            return [URLQueryItem(name: "product_id", value: productId), URLQueryItem(name: "next", value: next)]
        case .uploadImage:
            return nil
        case .inquerySpecificPost:
            return nil
        case .editPost:
            return [URLQueryItem(name: "product_id", value: "puding-moana22")]
        case .deletePost:
            return nil
        case .registerFunding:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .registerPost(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .inqueryPost:
            return nil
        case .uploadImage:
            return nil
        case .inquerySpecificPost:
            return nil
        case .editPost(let query, _):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .deletePost:
            return nil
        case .registerFunding(query: let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
}
