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

    @IBOutlet private weak var nameLocationTextField: UITextField!
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
        if formType == FormType.add.rawValue {
            viewModel.formTitle = CommonConstants.ADD_NEW_LOCATION
        } else {
            viewModel.formTitle = CommonConstants.EDIT_LOCATION
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formTitle.text = viewModel.formTitle
        viewModel.getCities().subscribe { cities in
            self.viewModel.city.accept(cities)
        }.disposed(by: viewModel.bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        setupPicker()
        
        // Nhấp vào District TextField load list District
        districtTextField.rx.controlEvent([.editingDidBegin]).subscribe { [weak self] _ in
            guard let self = self,
                  let city = self.cityTextField.text,
                  !(city.isEmpty)
            else { return }
            self.viewModel.getDistrictsByCityId(cityId: self.viewModel.city.value[self.viewModel.selectedCity].id)
                .subscribe { districts in
                    self.viewModel.district.accept(districts)
                }.disposed(by: self.viewModel.bag)
        }.disposed(by: viewModel.bag)
        
        // Nhấp vào Ward TextField load list ward
        wardTextField.rx.controlEvent([.editingDidBegin]).subscribe { [weak self] _ in
            guard let self = self,
                  let district = self.districtTextField.text,
                  !(district.isEmpty)
            else { return }
            self.viewModel.getWardsByDistrictId(districtId: self.viewModel.district.value[self.viewModel.selectedDistrict].id)
                .subscribe { wards in
                    self.viewModel.ward.accept(wards)
                }.disposed(by: self.viewModel.bag)
        }.disposed(by: viewModel.bag)
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
    
    @IBAction func onClickedSaveBtn(_ sender: UIButton) {
        viewModel.nameLocation = nameLocationTextField.text!
        viewModel.addressStreet = addressStreetTextField.text!
        viewModel.note = noteTextView.text!
        
        let location = Location(name: viewModel.nameLocation, type: viewModel.locationType.value[viewModel.selectedLocationType], address: viewModel.addressStreet, cityId: viewModel.city.value[viewModel.selectedCity].id, districtId: viewModel.district.value[viewModel.selectedDistrict].id, wardId: viewModel.ward.value[viewModel.selectedWard].id, note: viewModel.note, lat: viewModel.lat, long: viewModel.long)
        
        viewModel.addLocation(location)
            .subscribe { [weak self] location in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            } onCompleted: {
            }.disposed(by: viewModel.bag)
    }
    
    @objc private func donePicker(sender: UIBarButtonItem) {
        switch sender.tag {
        case PickerTag.locationType.rawValue:
            locationTypeTextField.text = viewModel.pickItem(pickerTag: sender.tag)
        case PickerTag.city.rawValue:
            cityTextField.text = viewModel.pickItem(pickerTag: sender.tag)
            districtTextField.text = ""
            districtPicker.reloadInputViews()
            wardTextField.text = ""
            wardPicker.reloadInputViews()
        case PickerTag.district.rawValue:
            guard let city = cityTextField.text,
                  !(city.isEmpty)
            else { return }
            districtTextField.text = viewModel.pickItem(pickerTag: sender.tag)
            wardTextField.text = ""
            wardPicker.reloadInputViews()
        case PickerTag.ward.rawValue:
            guard let district = districtTextField.text,
                  !(district.isEmpty)
            else { return }
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
        locationTypePicker.tag = PickerTag.locationType.rawValue
        locationTypeTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.locationType.rawValue)
        
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
        cityPicker.tag = PickerTag.city.rawValue
        cityTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.city.rawValue)
        
        viewModel.city.subscribe(on: MainScheduler.instance)
            .bind(to: cityPicker.rx.itemTitles) { (row, element) in
                return element.name
            }.disposed(by: viewModel.bag)
        
        cityPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedCity = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupDistrictPicker() {
        districtTextField.attributedPlaceholder = NSAttributedString(string: CommonConstants.DISTRICT_PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        districtTextField.inputView = districtPicker
        districtTextField.tintColor = .clear
        districtPicker.tag = PickerTag.district.rawValue
        districtTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.district.rawValue)
        
        viewModel.district.subscribe(on: MainScheduler.instance)
            .bind(to: districtPicker.rx.itemTitles) { (row, element) in
                return element.name
            }.disposed(by: viewModel.bag)
        
        districtPicker.rx.itemSelected.bind { (row: Int, component: Int) in
            self.viewModel.selectedDistrict = row
        }.disposed(by: viewModel.bag)
    }
    
    private func setupWardPicker() {
        wardTextField.attributedPlaceholder = NSAttributedString(string: CommonConstants.WARD_PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        wardTextField.inputView = wardPicker
        wardTextField.tintColor = .clear
        wardPicker.tag = PickerTag.ward.rawValue
        wardTextField.inputAccessoryView = setupPickerToolBar(pickerTag: PickerTag.ward.rawValue)
        
        viewModel.ward.subscribe(on: MainScheduler.instance)
            .bind(to: wardPicker.rx.itemTitles) { (row, element) in
                return element.name
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
