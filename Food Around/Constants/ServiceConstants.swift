//
//  ServiceConstants.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation

enum HTTPMethodSupport: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct StatusCode {
    static let OK = 200
    static let BAD_REQUEST = 400
    static let UNAUTHORIZED = 401
    static let SERVER_ERROR = 500
}

struct Base {
    static let URL = "http://192.168.1.157:8080/api/"
}

enum APIConstants: String {
    case login = "user/login"
    case register = "user/register"
    case getAllLocation = "location/all-location"
    case getLocationById = "location/" /// { id }
    case addLocation = "location/add-location"
    case findLocation = "location/find-location/" /// { searchString }
    case updateLocation = "location/update-location/" /// { id }
    case deleteLocation = "location/delete-location/" /// { id }
    case getAllCities = "city"
    case getDistrictsByCityId = "district/" /// { id }
    case getWardsByDistrictId = "ward/" /// { id }
    
    var method: HTTPMethodSupport {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        case .getAllLocation:
            return .get
        case .getLocationById:
            return .get
        case .addLocation:
            return .post
        case .findLocation:
            return .get
        case .updateLocation:
            return .put
        case .deleteLocation:
            return .delete
        case .getAllCities:
            return .get
        case .getDistrictsByCityId:
            return .get
        case .getWardsByDistrictId:
            return .get
        }
    }
}
