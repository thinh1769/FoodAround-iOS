//
//  BaseViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 20/12/2022.
//

import UIKit

class BaseController: UIViewController {

    var isHiddenNavigation = false {
        didSet {
            self.navigationController?.isNavigationBarHidden = isHiddenNavigation
        }
    }
    
    var isEnabledTouchDismissKeyboard = false {
        didSet {
            if isEnabledTouchDismissKeyboard {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHiddenNavigation = true
    }
    
    @objc func dismissKeyboard() {
        view.window?.endEditing(true)
    }
    
    func navigateTo(_ controller: UIViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
   
}
