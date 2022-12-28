//
//  LocationFormViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 22/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LocationFormViewController: BaseController {

    @IBOutlet private weak var formTitle: UILabel!
    @IBOutlet private weak var locationTypeTextField: CustomTextField!
    @IBOutlet private weak var cityTextField: CustomTextField!
    @IBOutlet private weak var districtTextField: CustomTextField!
    @IBOutlet private weak var wardTextField: CustomTextField!
    @IBOutlet private weak var addressStreetTextField: CustomTextField!
    @IBOutlet private weak var noteTextView: UITextView!
    
    var locationTypePicker = UIPickerView()
    var cityPicker = UIPickerView()
    var districtPicker = UIPickerView()
    var wardPicker = UIPickerView()
    var viewModel = LocationFormViewModel()
    
    func config(formType: Int, lat: Double, long: Double) {
        viewModel.lat = lat
        viewModel.long = long
        if formType == FormType.ADD_NEW_LOCATION_TYPE {
            viewModel.formTitle = CommonConstants.ADD_NEW_LOCATION
        } else {
            viewModel.formTitle = CommonConstants.EDIT_LOCATION
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formTitle.text = viewModel.formTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        setupPicker()
    }
    
    private func setupPicker() {
        setupLocationTypePicker()
        setupCityPicker()
        setupDistrictPicker()
        setupWardPicker()
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func donePicker(sender: UIBarButtonItem) {
        switch sender.tag {
        case PickerTag.LOCATION_TYPE:
            locationTypeTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        case PickerTag.CITY:
            cityTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        case PickerTag.DISTRICT:
            districtTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        case PickerTag.WARD:
            wardTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        default:
            return
        }
        view.endEditing(true)
    }
    
    @objc private func cancelPicker() {
        view.endEditing(true)
    }
    
    private func setupLocationTypePicker() {
        locationTypeTextField.attributedPlaceholder = NSAttributedString(string: CommonConstants.LOCATION_TYPE_PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        locationTypeTextField.inputView = locationTypePicker
        locationTypeTextField.tintColor = .clear
        locationTypePicker.tag = PickerTag.LOCATION_TYPE
        locationTypeTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.LOCATION_TYPE)
        
        viewModel.locationType.accept(CommonConstants.LOCATION_TYPE)
        
        viewModel.locationType.subscribe(on: MainScheduler.instance)
            .bind(to: locationTypePicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)
        
        locationTypePicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedLocationType = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupCityPicker() {
        cityTextField.attributedPlaceholder = NSAttributedString(string: CommonConstants.CITY_PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        cityTextField.inputView = cityPicker
        cityTextField.tintColor = .clear
        cityPicker.tag = PickerTag.CITY
        cityTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.CITY)
        
        viewModel.city.accept(CommonConstants.LOCATION_TYPE)
        
        viewModel.city.subscribe(on: MainScheduler.instance)
            .bind(to: cityPicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)
        
        cityPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedCity = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupDistrictPicker() {
        districtTextField.attributedPlaceholder = NSAttributedString(string: CommonConstants.DISTRICT_PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        districtTextField.inputView = districtPicker
        districtTextField.tintColor = .clear
        districtPicker.tag = PickerTag.DISTRICT
        districtTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.DISTRICT)
        
        viewModel.district.accept(CommonConstants.LOCATION_TYPE)
        
        viewModel.district.subscribe(on: MainScheduler.instance)
            .bind(to: districtPicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)
        
        districtPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedDistrict = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupWardPicker() {
        wardTextField.attributedPlaceholder = NSAttributedString(string: CommonConstants.WARD_PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        wardTextField.inputView = wardPicker
        wardTextField.tintColor = .clear
        wardPicker.tag = PickerTag.WARD
        wardTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.WARD)
        
        viewModel.ward.accept(CommonConstants.LOCATION_TYPE)
        
        viewModel.ward.subscribe(on: MainScheduler.instance)
            .bind(to: wardPicker.rx.itemTitles) { (row, element) in
                return element
            }.disposed(by: viewModel.bag)
        
        wardPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedWard = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupPickerToolBar(pickerTag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .clear
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: CommonConstants.DONE, style: .done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: CommonConstants.CANCEL, style: .plain, target: self, action: #selector(self.cancelPicker))
        
        cancelButton.tag = pickerTag
        doneButton.tag = pickerTag
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}
