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
    let bag = DisposeBag()
    let locationService = LocationService()
    let addressService = AddressService()
    var locationType = BehaviorRelay<[String]>(value: [])
    var city = BehaviorRelay<[City]>(value: [])
    var district = BehaviorRelay<[District]>(value: [])
    var ward = BehaviorRelay<[Ward]>(value: [])
    var selectedLocationType = 0
    var selectedCity = 0
    var selectedDistrict = 0
    var selectedWard = 0
    var lat = 0.0
    var long = 0.0
    var formTitle = ""
    var nameLocation = ""
    var addressStreet = ""
    var note = ""
    
    func pickItem(pickerTag: Int) -> String? {
        switch pickerTag{
        case PickerTag.LOCATION_TYPE:
            return locationType.value[selectedLocationType]
        case PickerTag.CITY:
            return city.value[selectedCity].name
        case PickerTag.DISTRICT:
            return district.value[selectedDistrict].name
        case PickerTag.WARD:
            return ward.value[selectedWard].name
        default:
            return ""
        }
    }
    
    func addLocation(_ location: Location) -> Observable<Location> {
        return locationService.addLocation(location: location)
    }
    
    func getCities() -> Observable<[City]> {
        return addressService.getAllCities()
    }
    
    func getDistrictsByCityId(cityId: String) -> Observable<[District]> {
        return addressService.getDistrictsByCityId(cityId: cityId)
    }
    
    func getWardsByDistrictId(districtId: String) -> Observable<[Ward]> {
        return addressService.getWardsByDistrictId(districtId: districtId)
    }
}
