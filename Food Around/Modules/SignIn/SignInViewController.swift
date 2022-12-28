//
//  SignInViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 19/12/2022.
//

import UIKit

class SignInViewController: BaseController {

    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var hidePasswordBtn: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        
        phoneTextField.text = "0934348847"
        passwordTextField.text = "111111"
    }

    @IBAction func onClickedSignUpBtn(_ sender: UIButton) {
        navigateTo(SignUpViewController())
    }
    
    @IBAction func onClickedForgotPasswordBtn(_ sender: UIButton) {
        navigateTo(OTPViewController())
    }
    
    @IBAction func onClickedSignInBtn(_ sender: UIButton) {
        viewModel.login(phone: phoneTextField.text!, password: passwordTextField.text!)
            .subscribe { user in
                UserDefaults.userInfo = user
                print("Đăng nhập thành công---------------------------------------\(UserDefaults.userInfo)")
                self.navigateTo(HomeViewController())
            }.disposed(by: viewModel.bag)
        
    }
    
    @IBAction func onClickedHidePasswordBtn(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            hidePasswordBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            hidePasswordBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
}
