//
//  UserInfoViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 28/12/2022.
//

import UIKit

class UserInfoViewController: BaseController {

    @IBOutlet private weak var editBtn: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    
    var viewModel = UserInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }
    
    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        textFieldIsEnable(false)
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickedSignOutBtn(_ sender: UIButton) {
        navigateTo(SignInViewController())
    }
    
    @IBAction func onClickedEditBtn(_ sender: UIButton) {
        textFieldIsEnable(!viewModel.ableEditing)
        viewModel.ableEditing = !viewModel.ableEditing
        if viewModel.ableEditing {
            editBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            editBtn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        }
    }
    
    private func textFieldIsEnable(_ status: Bool) {
        nameTextField.isEnabled = status
        phoneTextField.isEnabled = status
    }
}
