//
//  ShelterDetailView.swift
//  PuDingProj
//
//  Created by cho on 5/16/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ShelterDetailView: BaseView {
    
    let profileImageView = UIImageView()
    let profileInfoLabel = UILabel()
    let kindLabel = UILabel()
    let ageLabel = UILabel()
    let sexLabel = UILabel()
    let colorLabel = UILabel()
    let featureLabel = UILabel()
    let happenDateLabel = UILabel()
    let happenPlaceLabel = UILabel()
    let shelterInfoLabel = UILabel()
    let noticeDateLabel = UILabel()
    let shelterNameLabel = UILabel()
    let shelterTeleLabel = UILabel()
    let shelterPlaceLabel = UILabel()
    
    override func configureAttribute() {
        
    }
    
    override func configureViewLayout() {
        self.addSubviews([profileImageView, profileInfoLabel, kindLabel, ageLabel, sexLabel, colorLabel, featureLabel, happenDateLabel, happenDateLabel, shelterInfoLabel, noticeDateLabel, shelterNameLabel, shelterTeleLabel, shelterPlaceLabel])
    }
}
