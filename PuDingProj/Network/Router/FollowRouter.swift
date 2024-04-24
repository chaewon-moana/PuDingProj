//
//  FollowRouter.swift
//  PuDingProj
//
//  Created by cho on 4/24/24.
//

import Foundation
import Alamofire

enum FollowRouter {
    case follow(id: String)
    case unfollow(id: String)
}

extension FollowRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow:
            return .post
        case .unfollow:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .follow(let id):
            return "follow/\(id)"
        case .unfollow(let id):
            return "follow/\(id)"
        }
    }
    
    var header: [String : String] {
        return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken")!,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
