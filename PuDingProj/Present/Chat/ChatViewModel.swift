//
//  ChatViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class ChatViewModel {
    
    let disposeBag = DisposeBag()
    var messages: [RealChat] = []
    private var chatReceivedObserver: NSObjectProtocol?
    let repo = ChatRepository()
    
    
    struct Input {
        let inputTrigger: Observable<Void>
        let sendButtonTapped: Observable<Void>
        let sendText: Observable<String?>
        let backButtonTapped: Observable<Void>
        let roomID: Observable<String>
    }
    
    struct Output {
        let inputTrigger: Observable<[RealChat]>
        let backButtonTapped: Driver<Void>
    }
    
    deinit {
        SocketIOManager.shared.leaveConnection()
    }
    
    func transform(input: Input) -> Output {
        let outputMessage = BehaviorRelay(value: messages)
        let backButtonTapped = PublishRelay<Void>()
        //TODO: 이전화면에서 넘겨받는 걸로 변경
        let roomID = BehaviorRelay(value: "664ca7712b0224d656165bdd")
        
        input.backButtonTapped
            .withLatestFrom(input.roomID)
            .flatMap { id in
                return NetworkManager.requestNetwork(router: .chat(.inqueryChat(id: id, query: "")), modelType: InqueryChatModel.self)
            }
            .subscribe(with: self) { owner, model in
                print(model.data.count, "대체 몇개가 받아와지는거야")
                for item in model.data {
                    let sender = Participant(user_id: item.sender.user_id, nick: item.sender.nick, profileImage: item.sender.profileImage ?? "")
                    let emptyList = List<String>()
                    let data = EachChatInfo(chat_id: item.chat_id, room_id: item.room_id, content: item.content, createdAt: item.createdAt, sender: sender, files: emptyList)
                    owner.repo.addChatList(data: data)
                }
                backButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .withLatestFrom(input.sendText)
            .flatMap { value in
                let query = SendChatQuery(content: value!, files: [])
                return NetworkManager.requestNetwork(router: .chat(.sendChat(id: "664ca7712b0224d656165bdd", query: query)), modelType: SendChatModel.self)
            }
        //TODO: 여기서 뭐 처리를 안해줘도 됨??
            .subscribe(with: self) { owner, model in
                let item = RealChat(content: model.content!, createdAt: model.createdAt)
                print("보내짐")
            }
            .disposed(by: disposeBag)
        
        SocketIOManager.shared.receivedData
            .subscribe(with: self) { owner, chat in
                print("뷰모델에서 받음!")
                owner.messages.append(chat)
                outputMessage.accept(owner.messages)
            }
            .disposed(by: disposeBag)
        
        input.inputTrigger
            .subscribe(with: self) { owner, _ in
                //TODO: 넘어오면서 받은 데이터 넣기
               // repo.addChatList(data: EachChatInfo)
                SocketIOManager.shared.establishConnection()
//
//                owner.chatReceivedObserver = NotificationCenter.default.addObserver(forName: .chatReceived, object: nil, queue: nil) { notification in
//                           if let chat = notification.object as? RealChat {
//                               print("Received chat in ViewModel:", chat)
//                               owner.messages.append(chat)
//                               outputMessage.accept(owner.messages)
//                           }
//                       }
                let list = owner.repo.fetchChatList()
                for item in list {
                    let chat = RealChat(content: item.content, createdAt: item.createdAt)
                    owner.messages.append(chat)
                }
                print("되나용")
                outputMessage.accept(owner.messages)
            }
            .disposed(by: disposeBag)
        
        return Output(inputTrigger: outputMessage.asObservable(),
                      backButtonTapped: backButtonTapped.asDriver(onErrorJustReturn: ()))
    }
}
