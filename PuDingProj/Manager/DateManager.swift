//
//  DateManager.swift
//  PuDingProj
//
//  Created by cho on 5/2/24.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    func processData(date: String) -> String {
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertDate = dateFormatter.date(from: date)
        let resultDateFormatter = DateFormatter()
        resultDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        resultDateFormatter.locale = Locale(identifier:"ko_KR")
        let convertStr = resultDateFormatter.string(from: convertDate!)
        return convertStr
    }
    
    func calculateTimeDifference(_ date: String) -> String {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let targetDate = dateFormatter.date(from: date)!
        
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: targetDate, to: currentDate)
        print(components)
        
        let minute = components.minute!
        let hour = components.hour!
        let day = components.day!
        
        if minute == 0 {
            return "방금 "
        } else if minute < 60 && hour == 0 && day == 0 {
            return "\(minute)분"
        } else if day == 0 && hour >= 1 && hour < 24 {
            return "\(hour)시간"
        } else {
            return "\(day)일"
        }
    }

//        let todayFormatter = DateFormatter()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 2020-08-13 16:30
//        dateFormatter.locale = Locale(identifier:"ko_KR")
//        let today = todayFormatter.string(from: Date())
//        
//        let convertDate = dateFormatter.date(from: date) // Date 타입으로 변환
//        let startTime = dateFormatter.date(from: date)
//        let endTime = todayFormatter.date(from: today)
//        var useTime = Int(endTime!.timeIntervalSince(startTime!) / 60)
//        return String(userTime)
    
}
