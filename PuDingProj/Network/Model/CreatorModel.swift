//
//  CreatorModel.swift
//  PuDingProj
//
//  Created by cho on 4/21/24.
//

import Foundation

struct CreatorInfo: Decodable, Hashable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

