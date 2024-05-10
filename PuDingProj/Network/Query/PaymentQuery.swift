//
//  PaymentQuery.swift
//  PuDingProj
//
//  Created by cho on 5/9/24.
//

import Foundation

struct PaymentValidationQuery: Encodable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}
