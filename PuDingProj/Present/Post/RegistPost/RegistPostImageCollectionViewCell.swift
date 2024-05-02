//
//  RegistPostImageCollectionViewCell.swift
//  PuDingProj
//
//  Created by cho on 5/1/24.
//

import UIKit
import SnapKit

class RegistPostImageCollectionViewCell: UICollectionViewCell {
    let postImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func updateUI(image: UIImage?) {
        postImageView.image = image
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 20
    }
    
    private func configureView() {
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}
