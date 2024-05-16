//
//  ShelterCollectionViewCell.swift
//  PuDingProj
//
//  Created by cho on 5/15/24.
//

import UIKit
import SnapKit
import Kingfisher
class ShelterCollectionViewCell: UICollectionViewCell {
    
    let profileImageView = UIImageView()
    let regionTag = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubviews([profileImageView, regionTag])
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        regionTag.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
    }
    
    func updateUI(item: Item) {
        let url = URL(string: item.popfile)!
        downloadImageAndRetrieveSize(from: url) { image, size in
            self.profileImageView.image = image
            self.profileImageView.frame = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
        }
        profileImageView.kf.setImage(with: url)
        
        regionTag.text = item.careTel
    }
    
    func downloadImageAndRetrieveSize(from url: URL, completion: @escaping (UIImage?, CGSize?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                let size = image.size
                completion(image, size)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil, nil)
            }
        }
    }
    
    private func configureAttribute() {
        regionTag.text = "서울"
        regionTag.backgroundColor = .purple
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 8
        profileImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
