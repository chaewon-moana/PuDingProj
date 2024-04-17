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
    
}

struct InquiryPostQuery: Encodable {
    let product_id: String
}
