//
//  CommunityCollectionViewCell.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import SnapKit

final class CommunityCollectionViewCell: UICollectionViewCell {
    
    let categoryLabel = UILabel()
    let nicknameLabel = UILabel()
    let registerDate = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubviews([categoryLabel, nicknameLabel, registerDate, titleLabel, contentLabel])
        categoryLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        registerDate.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
    }
    private func configureAttribute() {
        categoryLabel.backgroundColor = .red
        categoryLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.backgroundColor = .orange
        nicknameLabel.font = .systemFont(ofSize: 15)
        registerDate.backgroundColor = .yellow
        registerDate.font = .systemFont(ofSize: 15)
        titleLabel.backgroundColor = .green
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentLabel.backgroundColor = .blue
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
    }
    
    func updateUI(item: inqueryPostModel) {
        categoryLabel.text = item.post_id
        nicknameLabel.text = item.content1
        registerDate.text = "| \(item.createdAt)"
        titleLabel.text = item.title
        contentLabel.text = item.content
        //MARK: dummy data
//        categoryLabel.text = "봉사모집"
//        nicknameLabel.text = "뫄뫄"
//        registerDate.text = "2222.222.22"
//        titleLabel.text = "제에모오오옥"
//        contentLabel.text = "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


