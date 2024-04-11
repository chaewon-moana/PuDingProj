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
