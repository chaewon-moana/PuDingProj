//
//  RealmManager.swift
//  PuDingProj
//
//  Created by cho on 5/22/24.
//

import Foundation
import RealmSwift

final class EachChatInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var chat_id: String
    @Persisted var room_id: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var sender: Participant?
    @Persisted var files: List<String>
    
    convenience init(chat_id: String, room_id: String, content: String, createdAt: String, sender: Participant, files: List<String>) {
        self.init()
        self.chat_id = chat_id
        self.room_id = room_id
        self.content = content
        self.createdAt = createdAt
        self.sender = sender
        self.files = files
    }
}

final class Participant: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var user_id: String //얘가 primary가 되어야함
    @Persisted var nick: String
    @Persisted var profileImage: String
    
    convenience init(user_id: String, nick: String, profileImage: String) {
        self.init()
        self.user_id = user_id
        self.nick = nick
        self.profileImage = profileImage
    }
}
