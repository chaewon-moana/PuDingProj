//
//  ChatModel.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import Foundation

struct ChatRoomModel: Decodable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [ChatRoomInfo]
    let lastChat: LastChatInfo?
}

struct ChatRoomInfo: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct LastChatInfo: Decodable {
    let chat_id: String
    let room_id: String
    let content: String
    let createdAt: String
    let sender: ChatRoomInfo
    let files: [String]?
}

struct InqueryChatRoomList: Decodable {
    let data: [ChatRoomModel]
}

struct InqueryChatModel: Decodable {
    let data: [LastChatInfo]
}

struct SendChatModel: Decodable {
    let chat_id: String
    let room_id: String
    let content: String?
    let createdAt: String
    let sender: ChatRoomInfo
    let files: [String]?
}

struct ChatImagesModel: Decodable {
    let files: [String]
}
