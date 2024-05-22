//
//  ChatViewModel.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatViewModel {
    
    let disposeBag = DisposeBag()
    var messages: [RealChat] = []
    private var chatReceivedObserver: NSObjectProtocol?
    
    struct Input {
        let inputTrigger: Observable<Void>
        let sendButtonTapped: Observable<Void>
        let sendText: Observable<String?>
    }
    
    struct Output {
        let inputTrigger: Observable<[RealChat]>
    }
    
    deinit {
        if let observer = chatReceivedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func transform(input: Input) -> Output {
        let outputMessage = BehaviorRelay(value: messages)
        
        input.sendButtonTapped
            .withLatestFrom(input.sendText)
            .flatMap { value in
                let query = SendChatQuery(content: value!, files: [])
                return NetworkManager.requestNetwork(router: .chat(.sendChat(id: "664ca7712b0224d656165bdd", query: query)), modelType: SendChatModel.self)
            }
        //TODO: 여기서 뭐 처리를 안해줘도 됨??
            .subscribe(with: self) { owner, model in
                let item = RealChat(content: model.content!, createdAt: model.createdAt)
                print("보내짐", owner.messages)
            }
            .disposed(by: disposeBag)

        
        input.inputTrigger
            .subscribe(with: self) { owner, _ in
                owner.chatReceivedObserver = NotificationCenter.default.addObserver(forName: .chatReceived, object: nil, queue: nil) { notification in
                           if let chat = notification.object as? RealChat {
                               print("Received chat in ViewModel:", chat)
                               owner.messages.append(chat)
                               outputMessage.accept(owner.messages)
                               print("호옥시 너도 되는거니")
                           }
                       }
            }
            .disposed(by: disposeBag)
        
        return Output(inputTrigger: outputMessage.asObservable())
    }
}
