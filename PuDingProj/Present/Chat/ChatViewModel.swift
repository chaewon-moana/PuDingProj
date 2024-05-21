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
        
        input.inputTrigger
            .subscribe(with: self) { owner, _ in
                owner.chatReceivedObserver = NotificationCenter.default.addObserver(forName: .chatReceived, object: nil, queue: nil) { notification in
                           if let chat = notification.object as? RealChat {
                               print("Received chat in ViewModel:", chat)
                               owner.messages.append(chat)
                               outputMessage.accept(owner.messages)
                           }
                       }
            }
            .disposed(by: disposeBag)
        
        return Output(inputTrigger: outputMessage.asObservable())
    }
}
