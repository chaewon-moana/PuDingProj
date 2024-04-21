//
//  ProfileModel.swift
//  PuDingProj
//
//  Created by cho on 4/21/24.
//

import Foundation

struct InqueryProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [CreatorInfo]
    let following: [CreatorInfo]
    let posts: [String]
}
