//
//  PostQuery.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import Foundation

struct RegisterPostQuery: Encodable {
    let title: String
    let content: String
    let content1: String //게시글 분류
    let product_id: String
    let files: [String]?
}

struct RegisterFundungQuery: Encodable {
    let title: String
    let content: String //상품 필요한 내용 간략히 적기
    let content1: String //상품 가격
    let content2: String //상품 갯수
    let content3: String //목표기한
    let content4: String //shelter 이름
    let product_id: String
    let files: [String]
}

//MARK: 이미지 업로드
struct UploadPostImageFilesQuery: Encodable {
    let files: [Data?]
}

struct SpecificPostQuery: Encodable {
    let next: String?
    let limit: String?
    let post_id: String?
}

struct EditPostQuery: Encodable {
    let content: String?
    let title: String?
    let content1: String?
    let product_id: String?
    let files: [String]?
}


