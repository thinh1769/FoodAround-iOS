//
//  SignUpViewModel.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    let bag = DisposeBag()
    let authService = AuthService()
    
    func register(phone: String, password: String, name: String) -> Observable<UserInfo> {
        return authService.registerUser(user: UserInfo(name: name, phoneNumber: phone, password: password))
    }
}
