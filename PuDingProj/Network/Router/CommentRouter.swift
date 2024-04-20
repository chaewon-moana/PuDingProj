//
//  CommentRouter.swift
//  PuDingProj
//
//  Created by cho on 4/21/24.
//

import Foundation
import Alamofire

enum CommentRouter {
    case writeComment(parameter: writeCommentQuery, id: String)
}

extension CommentRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .writeComment:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .writeComment(let parameter, let id):
            return "posts/\(id)/comments"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .writeComment:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken")!,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .writeComment:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .writeComment:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .writeComment(let query, let id):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
    
    
}
