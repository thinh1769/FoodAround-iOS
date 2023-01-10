//
//  DetailPopupView.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 09/01/2023.
//

import UIKit

class DetailPopupView: UIView {
    
    var nibName: String {
        return String(describing: DetailPopupView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
        nibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubView()
        nibSetup()
    }
    
    func setupSubView() {
        
    }
    
    func nibSetup() {
        let nibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!.first as! UIView
        nibView.frame = self.bounds
        addSubview(nibView)
    }
}
