//
//  ChatViewController.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import UIKit
import RxSwift
import RxCocoa

class ChatViewController: BaseViewController {
    
    let mainView = ChatView()
    let viewModel = ChatViewModel()
    let trigger = PublishRelay<Void>()
    var list: [RealChat] = []
    var chatList = PublishRelay<[RealChat]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let input = ChatViewModel.Input(inputTrigger: trigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .subscribe(with: self) { owner, list in
                owner.chatList.accept(list)
                print(owner.chatList.values)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func loadView() {
        view = mainView
    }
   

}
