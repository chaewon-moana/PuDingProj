//
//  PostModel.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation

struct RegisterPostModel: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
    let content1: String
    let createdAt: String
    let creator: RegisterPostDetail
}

struct RegisterPostDetail: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct inqueryUppperPostModel: Decodable {
    let data: [inqueryPostModel]
    let next_cursor: String
}

struct inqueryPostModel: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
    let content1: String
    let creator: InqueryPostCreatorInfo
}

struct InqueryPostCreatorInfo: Decodable {
    let user_id: String
    let nick: String
}
