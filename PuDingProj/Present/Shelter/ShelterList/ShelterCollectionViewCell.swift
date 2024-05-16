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
    let backView = UIView()
    let kindLabel = UILabel()
    let happendDateLabel = UILabel()
    let happendPlaceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAttribute()
    }
    
    private func configureLayout() {
        contentView.addSubviews([profileImageView, regionTag, backView])
        backView.addSubviews([kindLabel, happendDateLabel, happendPlaceLabel])
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        regionTag.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        kindLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(4)
        }
        happendDateLabel.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
        }
        happendPlaceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.top.equalTo(happendDateLabel.snp.bottom).offset(4)
        }
    }
    
    func updateUI(item: Item) {
        let url = URL(string: item.popfile)!
        profileImageView.kf.setImage(with: url)
        regionTag.text = item.noticeNo
        kindLabel.text = item.kindCD
        happendDateLabel.text = "발견날짜 : \(item.happenDt)"
        happendPlaceLabel.text = item.happenPlace
    }
    
//    func downloadImageAndRetrieveSize(from url: URL, completion: @escaping (UIImage?, CGSize?) -> Void) {
//        KingfisherManager.shared.retrieveImage(with: url) { result in
//            switch result {
//            case .success(let imageResult):
//                let image = imageResult.image
//                let size = image.size
//                completion(image, size)
//            case .failure(let error):
//                print("Error downloading image: \(error)")
//                completion(nil, nil)
//            }
//        }
//    }
    
    private func configureAttribute() {
        regionTag.text = "서울"
        regionTag.backgroundColor = .systemYellow
        regionTag.clipsToBounds = true
        regionTag.textColor = .white
        regionTag.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 8
        profileImageView.contentMode = .scaleAspectFill
        backView.backgroundColor = .black
        backView.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.7)
        //backView.layer.opacity = 0.5
        kindLabel.font = .systemFont(ofSize: 14)
        happendDateLabel.font = .systemFont(ofSize: 13)
        happendPlaceLabel.font = .systemFont(ofSize: 13)
        kindLabel.textColor = .white
        happendDateLabel.textColor = .white
        happendPlaceLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
