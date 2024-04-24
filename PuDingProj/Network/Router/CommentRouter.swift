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
    case editComment(query: writeCommentQuery, postID: String, commentID: String)
    case deleteComment(postID: String, commentID: String)
}

extension CommentRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .writeComment:
            return .post
        case .editComment:
            return .put
        case .deleteComment:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .writeComment(_, let id):
            return "posts/\(id)/comments"
        case .editComment(_, let postID, let commentID):
            return "posts/\(postID)/comments/\(commentID)"
        case .deleteComment(let postID, let commentID):
            return "posts/\(postID)/comments/\(commentID)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .writeComment:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .editComment:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .deleteComment:
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
        case .writeComment(let query, _):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .editComment(let query, _, _):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .deleteComment:
            return nil
        }
    }
    
    
}
