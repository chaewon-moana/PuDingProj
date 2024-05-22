//
//  ChatRouter.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    case makeChatRoom(query: ChatRoomQuery)
    case inqueryChatRoomList
    case inqueryChat(id: String, query: String?)
    case sendChat(id: String, query: SendChatQuery)
    case sendImageChat(id: String, query: SendChatImageQuery)
}

extension ChatRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .makeChatRoom:
            return .post
        case .inqueryChatRoomList:
            return .get
        case .inqueryChat:
            return .get
        case .sendChat:
            return .post
        case .sendImageChat:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .makeChatRoom:
            return "chats"
        case .inqueryChatRoomList:
            return "chats"
        case .inqueryChat(let id, _):
            return "chats/\(id)"
        case .sendChat(let id, _):
            return "chats/\(id)"
        case .sendImageChat(let id, _):
            return "chats/\(id)/files"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .makeChatRoom:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .inqueryChatRoomList:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .inqueryChat:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .sendChat:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .sendImageChat:
            return [HTTPHeader.authorization.rawValue: UserDefault.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue]
        }
    }
    
    var parameters: String? {
        switch self {
        case .makeChatRoom:
            return nil
        case .inqueryChatRoomList:
            return nil
        case .inqueryChat:
            return nil
        case .sendChat:
            return nil
        case .sendImageChat:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .makeChatRoom:
            return nil
        case .inqueryChatRoomList:
            return nil
        case .inqueryChat(_, let query):
            return [URLQueryItem(name: "cursor_date", value: query)]
        case .sendChat:
            return nil
        case .sendImageChat:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .makeChatRoom(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .inqueryChatRoomList:
            return nil
        case .inqueryChat:
            return nil
        case .sendChat(_, let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .sendImageChat(_, let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
}
