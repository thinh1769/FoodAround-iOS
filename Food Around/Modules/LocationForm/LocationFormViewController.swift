//
//  LocationFormViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 22/12/2022.
//

import UIKit

class LocationFormViewController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
