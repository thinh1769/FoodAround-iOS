//
//  LocationFormViewModel.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 26/12/2022.
//

import Foundation
import RxRelay
import RxSwift

class LocationFormViewModel {
    var bag = DisposeBag()
    var locationType = BehaviorRelay<[String]>(value: [])
    var city = BehaviorRelay<[String]>(value: [])
    var district = BehaviorRelay<[String]>(value: [])
    var ward = BehaviorRelay<[String]>(value: [])
    var selectedLocationType = 0
    var selectedCity = 0
    var selectedDistrict = 0
    var selectedWard = 0
    var lat = 0.0
    var long = 0.0
    var formTitle = ""
    
    func pickItem(pickerTag: Int) -> String? {
        switch pickerTag{
        case PickerTag.LOCATION_TYPE:
            return locationType.value[selectedLocationType]
        case PickerTag.CITY:
            return city.value[selectedCity]
        case PickerTag.DISTRICT:
            return district.value[selectedDistrict]
        case PickerTag.WARD:
            return ward.value[selectedWard]
        default:
            return ""
        }
        
    }
}
