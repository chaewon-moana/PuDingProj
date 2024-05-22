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
        chatSendView.addSubviews([chatTextField, chatSendButton])
        chatTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        chatSendView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        chatTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        chatSendButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
        
    }
    
    override func configureAttribute() {
        chatTableView.backgroundColor = .blue
        chatSendView.backgroundColor = .green
        chatSendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        chatTextField.placeholder = "메시지 입력해주세요"
        chatTextField.layer.borderColor = UIColor.black.cgColor
        chatTextField.layer.borderWidth = 1
    }
}
