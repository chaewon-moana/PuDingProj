//
//  UserDefaultsManager.swift
//  PuDingProj
//
//  Created by cho on 4/24/24.
//

import UIKit

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


enum UserDefault {
    enum Key: String {
        case accessToken
        case refreshToken
        case saveEmail
    }
    @WrapperDefaults(key: Key.accessToken.rawValue, defaultValue: "")
    static var accessToken
    @WrapperDefaults(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    @WrapperDefaults(key: Key.saveEmail.rawValue, defaultValue: "")
    static var saveEmail

}


class UserDefault {
    private init() { }
    
    static let  = UserDefault()
    
    let ud = UserDefaults.standard
    
    enum UDKey: String {
        case accessToken
        case refreshToken
        case saveEmail
    }
    
    var accessToken: String {
        get {
            ud.string(forKey: UDKey.accessToken.rawValue) ?? ""
        }
        set {
            ud.set(newValue, forKey: UDKey.accessToken.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            ud.string(forKey: UDKey.refreshToken.rawValue) ?? ""
        }
        set {
            ud.set(newValue, forKey: UDKey.refreshToken.rawValue)
        }
    }
    
    var saveEmail: String {
        get {
            ud.string(forKey: UDKey.saveEmail.rawValue) ?? ""
        }
        set {
            ud.set(newValue, forKey: UDKey.saveEmail.rawValue)
        }
    }
    
}
