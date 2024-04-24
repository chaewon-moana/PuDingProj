//
//  Router.swift
//  PuDingProj
//
//  Created by cho on 4/20/24.
//

import Foundation

enum Router {
    case account(AccountRouter)
    case post(PostRouter)
    case comment(CommentRouter)
    case profile(ProfileRouter)
    case like(LikeRouter)
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .account(let accountRouter):
            return try accountRouter.asURLRequest()
        case .post(let postRouter):
            return try postRouter.asURLRequest()
        case .comment(let commentRouter):
            return try commentRouter.asURLRequest()
        case .profile(let profileRouter):
            return try profileRouter.asURLRequest()
        case .like(let likeRouter):
            return try likeRouter.asURLRequest()
        }
    }
}
