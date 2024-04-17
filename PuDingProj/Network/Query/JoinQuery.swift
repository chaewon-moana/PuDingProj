//
//  LoginQuery.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import Foundation

struct JoinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
    //let birthDay: String?
}

struct emailQuery: Encodable {
    let email: String
}

struct LoginQuery: Encodable {
    let email: String
    let password: String
}
