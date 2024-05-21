//
//  SocketIOManager.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import Foundation
import SocketIO

struct RealChat: Decodable, Hashable {
    let content: String
    let createdAt: String
}

extension Notification.Name {
    static let socketConnected = Notification.Name("socketConnected")
    static let socketDisconnected = Notification.Name("socketDisconnected")
    static let chatReceived = Notification.Name("chatReceived")
}

final class SocketIOManager {
    static let shared = SocketIOManager()
    
    var manager: SocketManager!//어떤 url 기반으로 할건지?
    var socket: SocketIOClient!
        
    let baseURL = URL(string: APIKey.baseURL.rawValue)!
    let roomID = "/chats-664ca7712b0224d656165bdd"
    
    private init () {
        print("SocketIOManager Init")
        manager = SocketManager(socketURL: baseURL, config: [.log(true), .compress])
        socket = manager.socket(forNamespace: roomID)
        
        socket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결됨")
            print(data)
            NotificationCenter.default.post(name: .socketConnected, object: nil)
        }
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 끊김")
            NotificationCenter.default.post(name: .socketDisconnected, object: nil)
        }
        
        socket.on("chat") { dataArray, ack in
            //print("chat received: 소켓 채팅 받음!", dataArray, ack)
            if let data = dataArray.first { //원래 do - try catch 문으로 다 바꿔줘야함
                let result = try? JSONSerialization.data(withJSONObject: data) //요걸로 Any를 Data로 바꿔줘야함
                let decodedData = try? JSONDecoder().decode(RealChat.self, from: result!) //data가 Any 배열이라 안됨!
                NotificationCenter.default.post(name: .chatReceived, object: decodedData)
            }
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func leaveConnection() {
        socket.disconnect()
    }
    
}
