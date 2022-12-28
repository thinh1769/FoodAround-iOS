//
//  AuthService.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation
import Alamofire
import RxSwift

class AuthService: BaseService {
    func loginUser(phone: String, password: String) -> Observable<UserInfo> {
        let params = ["phoneNumber": phone, "password": password]
        return authRequest(api: APIConstants.login, method: .post, parameters: params)
    }
    
    func registerUser(user: UserInfo) -> Observable<UserInfo> {
        return authRequest(api: APIConstants.register, method: .post, parameters: user)
    }
}
