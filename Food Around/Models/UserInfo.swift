//
//  UserInfo.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation

struct UserInfo: Codable {
    var id: String?
    var name: String
    var phoneNumber: String
    var password: String?
    var token: String?
}
