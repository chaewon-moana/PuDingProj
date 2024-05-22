//
//  ChatRepository.swift
//  PuDingProj
//
//  Created by cho on 5/22/24.
//

import Foundation
import RealmSwift

final class ChatRepository {
    
    private let realm = try! Realm()
    
    func fetchChatList() -> [EachChatInfo] {
        let result = realm.objects(EachChatInfo.self)
        return Array(result)
    }
    
    func updateChatList() -> Results<EachChatInfo> {
        return realm.objects(EachChatInfo.self)
    }
    
    func addChatList(data: EachChatInfo) {
        do {
            try realm.write {
                realm.add(data)
            }
        }
        catch {
            print("ChatRepository - addChatList error")
        }
    }
}
