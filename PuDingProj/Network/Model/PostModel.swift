//
//  PostModel.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation
//MARK: 
struct RegisterPostModel: Decodable {
    let post_id: String
    let product_id: String
    let title: String?
    let content: String?
    let content1: String?
    let createdAt: String
    let creator: RegisterPostDetail
    let files: [String]?
    let likes: [String]
    let likes2: [String]?
    let hashTags: [String]?
    let comments: [RegisterPostComment]?
    
}
struct RegisterPostDetail: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
struct RegisterPostComment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: CreatorInfo
}

//MARK: Post 조회
struct inqueryUppperPostModel: Decodable {
    let data: [inqueryPostModel]
    let next_cursor: String
}

//TODO: 포스트 작성 시, 모두 선택이므로 옵셔널로 작성
struct inqueryPostModel: Decodable {
    let post_id: String
    let product_id: String?
    let title: String?
    let content: String?
    let content1: String?
    let createdAt: String
    let creator: CreatorInfo
}


//MARK: 이미지 업로드
struct UploadPostImageFilesModel: Decodable {
    let files: [String]
}



