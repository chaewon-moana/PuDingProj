//
//  LoginModel.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation

struct JoinModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

struct emailValidationModel: Decodable {
    let message: String
}

struct LoginModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
