//
//  ChatViewController.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import UIKit

class ChatViewController: BaseViewController {
    
    let mainView = ChatView()
    let viewModel = ChatViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "채애티잉"
    }
    
    override func bind() {
        
    }
    
    override func loadView() {
        view = mainView
    }
   

}
