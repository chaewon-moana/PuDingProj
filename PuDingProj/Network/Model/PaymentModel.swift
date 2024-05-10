//
//  PaymentModel.swift
//  PuDingProj
//
//  Created by cho on 5/9/24.
//

import Foundation

struct PaymentValidationModel: Decodable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}

struct PaymentsModel: Decodable {
    let data: [PaymentMeModel]
}

struct PaymentMeModel: Decodable {
    let payment_id: String
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
