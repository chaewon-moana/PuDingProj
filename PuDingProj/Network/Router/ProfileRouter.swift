//
//  ProfileRouter.swift
//  PuDingProj
//
//  Created by cho on 4/21/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case inqueryProfile
    case editProfile(query: EditProfileQuery)
   // case inqueryOtherProfile(parameter: String)
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .inqueryProfile:
            return .get
        case .editProfile:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .inqueryProfile:
            return "users/me/profile"
        case .editProfile:
            return "users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .inqueryProfile:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken")!,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .editProfile:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken")!,
             HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
             HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        switch self {
        case .inqueryProfile:
            return nil
        case .editProfile:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .inqueryProfile:
            return nil
        case .editProfile(let query):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .inqueryProfile:
            return nil
        case .editProfile(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
    
    
}
