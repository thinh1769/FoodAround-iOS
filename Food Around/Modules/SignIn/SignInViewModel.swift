//
//  SignInViewModel.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 28/12/2022.
//

import Foundation
import RxSwift
import RxRelay

class SignInViewModel {
    let bag = DisposeBag()
    let authService = AuthService()
    
    func login(phone: String, password: String) -> Observable<UserInfo> {
        return authService.loginUser(phone: phone, password: password)
    }
}
