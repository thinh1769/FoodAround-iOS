//
//  OTPViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 20/12/2022.
//

import UIKit

class OTPViewController: BaseController {

    @IBOutlet private weak var OTPView: UIView!
    @IBOutlet private weak var OTPTextField: UITextField!
    
    var arrayOTPLabel: [UILabel] = []
    let OTPStackView = UIStackView()
    let numberOfOTP = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        OTPTextField.tintColor = .clear
        OTPTextField.textColor = .clear
        OTPTextField.delegate = self
        setupOTPStackView()
    }
    
    private func setupOTPStackView() {
        OTPStackView.axis = .horizontal
        OTPStackView.distribution = .fillEqually
        OTPStackView.alignment = .center
        OTPStackView.spacing = 7
        
        for _ in 0 ... (numberOfOTP - 1) {
            let OTPLabel = createOTPLabel()
            OTPStackView.addArrangedSubview(OTPLabel)
            arrayOTPLabel.append(OTPLabel)
        }
        
        OTPStackView.translatesAutoresizingMaskIntoConstraints = false
        OTPView.addSubview(OTPStackView)
        OTPView.sendSubviewToBack(OTPStackView)
        
        OTPStackView.leadingAnchor.constraint(equalTo: OTPTextField.leadingAnchor).isActive = true
        OTPStackView.trailingAnchor.constraint(equalTo: OTPTextField.trailingAnchor).isActive = true
        OTPStackView.topAnchor.constraint(equalTo: OTPTextField.topAnchor, constant: 10).isActive = true
    }
    
    private func createOTPLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "lightTheme")
        label.widthAnchor.constraint(equalToConstant: OTPTextField.bounds.width / CGFloat(numberOfOTP)).isActive = true
        label.heightAnchor.constraint(equalToConstant: 75).isActive = true
        label.layer.cornerRadius = 8
        label.textColor = UIColor(named: "themeColor")
        label.font = .boldSystemFont(ofSize: 50)
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            if arrayOTPLabel[numberOfOTP - 1].text != nil {
                return false
            } else {
                for i in 0...numberOfOTP - 1 {
                    if arrayOTPLabel[i].text == nil {
                        arrayOTPLabel[i].text = string
                        return true
                    }
                }
            }
        }
        if string == "" {
            for i in (0...numberOfOTP - 1).reversed() {
                if arrayOTPLabel[i].text != nil {
                    arrayOTPLabel[i].text = nil
                    return true
                }
            }
        }
        OTPTextField.text = ""
        return false
    }
}
