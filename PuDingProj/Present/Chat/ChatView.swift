//
//  ChatView.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import UIKit
import SnapKit

final class ChatView: BaseView {
    
    let chatTableView = UITableView()
    let chatSendView = UIView()
    let chatTextField = UITextField()
    let chatSendButton = UIButton()
   
    override func configureViewLayout() {
        self.addSubviews([chatTableView, chatSendView])
    }
    
    override func configureAttribute() {
        
    }
}
