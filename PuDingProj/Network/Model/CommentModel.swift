//
//  CommentModel.swift
//  PuDingProj
//
//  Created by cho on 4/21/24.
//

import Foundation

struct WriteCommentModel: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: CreatorInfo
}
