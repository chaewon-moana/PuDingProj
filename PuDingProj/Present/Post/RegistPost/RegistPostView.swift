//
//  RegistPostView.swift
//  PuDingProj
//
//  Created by cho on 4/18/24.
//

import UIKit
import SnapKit

final class RegistPostView: BaseView {
    let categoryButton = UIButton()
    let titleTextView = UITextView()
    //let titleTextCountLabel = UILabel()
    let contentTextView = UITextView()
    let addImageButton = UIButton()
    let testImageView = UIImageView()
    let addPostButton = UIButton()
    let tmpButton = UIButton()
    
    override func configureAttribute() {
        categoryButton.setTitle("카테고리 영역", for: .normal)
        categoryButton.backgroundColor = .systemYellow
        titleTextView.text = "하이헬로우"
        titleTextView.backgroundColor = .systemYellow
        contentTextView.text = "contentView라능"
        contentTextView.backgroundColor = .systemYellow
        addPostButton.setTitle("저장", for: .normal)
        addPostButton.backgroundColor = .red
        addImageButton.setTitle("이미지 저장", for: .normal)
        addImageButton.backgroundColor = .purple
        testImageView.image = UIImage(systemName: "star")
        tmpButton.setTitle("임시버튼", for: .normal)
        tmpButton.backgroundColor = .systemYellow
    }
    
    override func configureViewLayout() {
        self.addSubviews([categoryButton, titleTextView, contentTextView, addImageButton, addPostButton, testImageView, tmpButton])
        categoryButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        tmpButton.snp.makeConstraints { make in
            make.leading.equalTo(categoryButton.snp.trailing).offset(20)
            make.top.equalTo(categoryButton)
        }

        titleTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(categoryButton.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        contentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(titleTextView.snp.bottom).offset(12)
            make.height.equalTo(140)
        }
        addPostButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
        }
        addImageButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(addPostButton.snp.top).offset(-20)
            make.height.equalTo(40)
        }
        testImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
    }
    
}
