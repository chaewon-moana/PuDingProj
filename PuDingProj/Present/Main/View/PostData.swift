//
//  PostData.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation

struct RegisterPost: Decodable, Hashable {
    let post_id: String
    let product_id: String //분류값
    let title: String
    let content: String
    let content1: String
    let createdAt: String
    let creator: CreatorInfo
    
}

struct CreatorInfo: Decodable, Hashable {
    let user_id: String
    let nick: String
    let prifileImage: String?
}
