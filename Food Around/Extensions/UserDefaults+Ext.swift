//
//  UserDefaults+Ext.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation

extension UserDefaults {
    private enum Key: String {
        case userInfo = "UserInfo"
    }
    
    private static let UDStandard = UserDefaults.standard
    
    static var userInfo: UserInfo? {
        get {
            let data = UDStandard.object(forKey: Key.userInfo.rawValue) as? Data
            guard data != nil else { return nil }
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data! )
            return userInfo
        }
        set {
            guard let value = newValue else {
                UDStandard.removeObject(forKey: Key.userInfo.rawValue)
                return
            }
            let data = try? JSONEncoder().encode(value)
            if data != nil {
                UDStandard.set(data, forKey: Key.userInfo.rawValue)
            }
        }
    }
}
