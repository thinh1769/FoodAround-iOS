//
//  SignUpViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 19/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseController {

    @IBOutlet private weak var hidePasswordBtn: UIButton!
    @IBOutlet private weak var hideConfirmPassBtn: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var confirmPassTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    
    var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        phoneTextField.text = "0000022222"
        passwordTextField.text = "111111"
        confirmPassTextField.text = "111111"
        
        isEnabledTouchDismissKeyboard = true
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickedSignUpBtn(_ sender: UIButton) {
        viewModel.register(phone: phoneTextField.text!, password: passwordTextField.text!, name: nameTextField.text!)
            .subscribe { user in
                UserDefaults.userInfo = user
                print("Đăng kí thành công----------------------------------------")
                self.navigateTo(SignInViewController())
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
    @IBAction func onClickedHideConfirmPassBtn(_ sender: UIButton) {
        if confirmPassTextField.isSecureTextEntry {
            confirmPassTextField.isSecureTextEntry = false
            hideConfirmPassBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            confirmPassTextField.isSecureTextEntry = true
            hideConfirmPassBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
}
