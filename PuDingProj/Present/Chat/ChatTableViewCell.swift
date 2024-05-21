//
//  ChatTableViewCell.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import UIKit
import SnapKit

final class ChatTableViewCell: UITableViewCell {

    let chatLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubview(chatLabel)
        chatLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(8)
        }
    }
    
    private func configureAttribute() {
        chatLabel.backgroundColor = .blue
        chatLabel.textColor = .white
        chatLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
