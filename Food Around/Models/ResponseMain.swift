//
//  ResponseMain.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation

class ResponseMain<Payload: Codable>: Codable {
    var statusCode: Int
    var message: String
    var payload: Payload? = nil
}
