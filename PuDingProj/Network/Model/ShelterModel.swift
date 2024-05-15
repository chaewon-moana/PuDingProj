//
//  ShelterModel.swift
//  PuDingProj
//
//  Created by cho on 5/15/24.
//

import Foundation


// MARK: - Welcome
struct MainResponse: Decodable {
    let response: ShelterResponse
}

struct ShelterResponse: Decodable {
    let header: Header
    let body: ShelterBody
}

struct ShelterBody: Decodable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let desertionNo: String
    let filename: String //이미지 화질 안 좋음,,,,
    let happenDt, happenPlace, kindCD, colorCD: String
    let age, weight, noticeNo, noticeSdt, noticeEdt: String
    let popfile: String //이미지 파일
    let processState: String
    let sexCD: String //F, M
    let neuterYn: NeuterYn //중성화 유무?
    let specialMark, careNm, careTel, careAddr: String
    let orgNm, chargeNm: String //orgNm -> ㅇㅇ시 ㅇㅇ구
    let officetel: String //전화번호

    enum CodingKeys: String, CodingKey {
        case desertionNo, filename, happenDt, happenPlace
        case kindCD = "kindCd"
        case colorCD = "colorCd"
        case age, weight, noticeNo, noticeSdt, noticeEdt, popfile, processState
        case sexCD = "sexCd"
        case neuterYn, specialMark, careNm, careTel, careAddr, orgNm, chargeNm, officetel
    }
}

enum NeuterYn: String, Codable {
    case n = "N"
    case u = "U"
}

//enum SexCD: String, Codable {
//    case f = "F"
//    case m = "M"
//}

struct Header: Codable {
    let reqNo: Int
    let resultCode, resultMsg: String
}
