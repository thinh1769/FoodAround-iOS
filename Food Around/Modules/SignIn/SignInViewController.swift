//
//  SignInViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 19/12/2022.
//

import UIKit

class SignInViewController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
    }

    @IBAction func onClickedSignUpBtn(_ sender: UIButton) {
        navigateTo(SignUpViewController())
    }
    
    @IBAction func onClickedForgotPasswordBtn(_ sender: UIButton) {
        navigateTo(OTPViewController())
    }
    
    @IBAction func onClickedSignInBtn(_ sender: UIButton) {
        navigateTo(HomeViewController())
    }
}
