//
//  DetailPopupView.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 09/01/2023.
//

import UIKit

protocol DetailPopupViewDelegate: AnyObject {
    func deselectedAnnotationWhenDismissDetailPopup()
    
    func onClickedEditLocationButton(_ location: Location)
}

class DetailPopupView: UIView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    
    private let viewModel = DetailPopupViewModel()
    weak var delegate: DetailPopupViewDelegate?
    
    var nibName: String {
        return String(describing: DetailPopupView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
        setupSubView()
    }
    
    private func setupSubView() {
        noteTextView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        addPanGestureToDetailPopup()
    }
    
    func fetchData(_ locationId: String) {
        viewModel.getLocationById(locationId).subscribe { [weak self] location in
            guard let self = self else { return }
            self.viewModel.locationDetail = location
            self.setupData()
        }.disposed(by: viewModel.bag)
        
    }
    
    private func setupData() {
        nameLabel.text = viewModel.locationDetail?.name
        typeLabel.text = viewModel.locationDetail?.type
        addressLabel.text = parsingAddress()
        noteTextView.text = viewModel.locationDetail?.note
    }
    
    private func parsingAddress() -> String {
        return "\(viewModel.locationDetail?.address ?? ""), \(viewModel.locationDetail?.ward?.name ?? ""), \(viewModel.locationDetail?.district?.name ?? ""), \(viewModel.locationDetail?.city?.name ?? "")"
    }
    
    private func addPanGestureToDetailPopup() {
        let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        self.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        gesture.location(in: self)
        switch gesture.state {
        case .began:
            print("began")
        case .changed:
            if translation.y > 0 {
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 {
                UIView.animateKeyframes(withDuration: 0.4, delay: 0) {
                    self.transform = CGAffineTransform(translationX: 0, y: 260)
                } completion: { _ in
                    self.removeFromSuperview()
                    self.delegate?.deselectedAnnotationWhenDismissDetailPopup()
                }
            } else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 1) {
                    self.transform = .identity
                }
            }
            print("end")
        case .possible:
            print("possible")
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        default:
            print("default")
        }
    }
    
    @IBAction func onClickedEditLocationBtn(_ sender: UIButton) {
        guard let location = viewModel.locationDetail else { return }
        self.delegate?.onClickedEditLocationButton(location)
    }
    
    func nibSetup() {
        let nibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!.first as! UIView
        nibView.frame = self.bounds
        addSubview(nibView)
    }
}
