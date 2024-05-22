//
//  ChatTableViewCell.swift
//  PuDingProj
//
//  Created by cho on 5/21/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ChatTableViewCell: UITableViewCell {

    let chatLabel = UILabel()
    let profileImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubviews([chatLabel, profileImageView])
        chatLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(8)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
    }
    
    func updateUI(item: RealChat) {
        chatLabel.text = item.content
    }
    
    private func configureAttribute() {
        chatLabel.backgroundColor = .blue
        chatLabel.textColor = .white
        chatLabel.numberOfLines = 0
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
