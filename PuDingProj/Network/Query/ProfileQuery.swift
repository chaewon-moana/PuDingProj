//
//  ProfileQuery.swift
//  PuDingProj
//
//  Created by cho on 4/21/24.
//

import Foundation

struct EditProfileQuery: Encodable {
    let nick: String?
    let phoneNum: String?
    //let birthDay: String?
    let profile: Data?
}
