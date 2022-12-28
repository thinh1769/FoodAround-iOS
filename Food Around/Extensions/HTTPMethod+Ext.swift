//
//  HTTPMethod+Ext.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 28/12/2022.
//

import Foundation
import Alamofire

extension HTTPMethod {
    static func convert(_ methodSupport: HTTPMethodSupport) -> Self? {
        if methodSupport == .post { return .post }
        else if methodSupport == .get { return .get }
        else if methodSupport == .put { return .put }
        else if methodSupport == .patch { return .patch }
        else if methodSupport == .delete { return .delete }
        else { return nil }
    }
}
