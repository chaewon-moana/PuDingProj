//
//  ShelterNetworkManager.swift
//  PuDingProj
//
//  Created by cho on 5/15/24.
//

import Foundation
import Alamofire

struct ShelterNetworkManager {
    
    static let shared = ShelterNetworkManager()
    
    func request(pageNo: Int, completionHandler: @escaping (MainResponse) -> Void) {
        let url = APIKey.shelterURL.rawValue
        let parameter: Parameters = ["serviceKey": APIKey.shelterID.rawValue, "_type": "json", "numOfRows": "20", "pageNo": "\(pageNo)"]
        AF.request(url, parameters: parameter).responseDecodable(of: MainResponse.self) { response in
            switch response.result {
            case .success(let success):
                print(success)
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
}
