//
//  ChatViewController.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ChatViewController: BaseViewController {
    
    let mainView = ChatView()
    let viewModel = ChatViewModel()
    let trigger = PublishRelay<Void>()
    var list: [RealChat] = []
    var chatList = PublishRelay<[RealChat]>()
    var roomInfo: InqueryChatModel!
    var backButton = UIBarButtonItem(title: "백", style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        let realm = try! Realm()
        print(realm.configuration.fileURL)
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "채애티잉"
        SocketIOManager.shared.establishConnection()
        trigger.accept(())
        mainView.chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        chatList
            .bind(to: mainView.chatTableView.rx.items(cellIdentifier: "ChatTableViewCell", cellType: ChatTableViewCell.self)) { (index, item, cell) in
                cell.updateUI(item: item)
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = ChatViewModel.Input(inputTrigger: trigger.asObservable(),
                                        sendButtonTapped: mainView.chatSendButton.rx.tap.asObservable(),
                                        sendText: mainView.chatTextField.rx.text.asObservable(),
                                        backButtonTapped: backButton.rx.tap.asObservable(),
                                        roomID: Observable.just("664ca7712b0224d656165bdd"))
        
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .subscribe(with: self) { owner, list in
                owner.chatList.accept(list)
                print(owner.chatList.values)
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func loadView() {
        view = mainView
    }
   

}
