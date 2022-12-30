//
//  Location.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 28/12/2022.
//

import Foundation

struct Location: Codable {
    var id: String?
    var name: String?
    var type: String
    var address: String
    var city: City?
    var district: District?
    var ward: Ward?
    var cityId: String?
    var districtId: String?
    var wardId: String?
    var note: String
    var lat: Double
    var long: Double
}

struct City: Codable {
    var id: String
    var name: String
}

struct District: Codable {
    var id: String
    var name: String
}

struct Ward: Codable {
    var id: String
    var name: String
}
