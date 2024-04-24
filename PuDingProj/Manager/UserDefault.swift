//
//  UserDefaultsManager.swift
//  PuDingProj
//
//  Created by cho on 4/24/24.
//

import UIKit

enum UserDefault {
    enum Key: String {
        case accessToken
        case refreshToken
        case saveEmail
        case userID
    }
    @WrapperDefaults(key: Key.accessToken.rawValue, defaultValue: "")
    static var accessToken
    @WrapperDefaults(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    @WrapperDefaults(key: Key.saveEmail.rawValue, defaultValue: "")
    static var saveEmail
    @WrapperDefaults(key: Key.userID.rawValue, defaultValue: "")
    static var userID
}

@propertyWrapper
struct WrapperDefaults<T> {
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
