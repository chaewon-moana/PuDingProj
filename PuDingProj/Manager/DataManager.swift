//
//  DataManager.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import Foundation

enum categoryData: String, CaseIterable {
    case attractingSponsor = "후원모집"
    case volunteerReview = "봉사후기"
    case needToHelp = "도움이 필요해요"
    case donationGoods = "물품 기부해요"
    case smallTalk = "잡담"
    
}

class MoneyFormatter {
    static let shared = MoneyFormatter()
    
    private let formatter: NumberFormatter
    
    private init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.currencyGroupingSeparator = "," // 천 단위 구분 기호
        formatter.maximumFractionDigits = 0
    }
    
    func string(from number: NSNumber) -> String {
        return formatter.string(from: number)!
    }
}


