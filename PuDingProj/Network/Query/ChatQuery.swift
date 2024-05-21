//
//  ChatQuery.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import Foundation

struct ChatRoomQuery: Encodable {
    let oppenent_id: String
}

struct SendChatQuery: Encodable {
    let content: String
    let files: [String]
}

struct SendChatImageQuery: Encodable {
    let files: [String]
}
