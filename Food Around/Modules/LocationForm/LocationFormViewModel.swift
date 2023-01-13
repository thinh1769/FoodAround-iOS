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
    var cityId = ""
    var districtId = ""
    var wardId = ""
    var lat = 0.0
    var long = 0.0
    var formTitle = ""
    var nameLocation = ""
    var addressStreet = ""
    var note = ""
    var location: Location?
    
    func config(formType: Int, location: Location?, lat: Double?, long: Double?) {
        if formType == FormType.add.rawValue {
            guard let lat = lat,
                  let long = long
            else { return }
            self.lat = lat
            self.long = long
            self.formTitle = CommonConstants.ADD_NEW_LOCATION
        } else {
            guard let location = location,
                  let cityId = location.city?.id,
                  let districtId = location.district?.id,
                  let wardId = location.ward?.id
            else { return }
            self.location = location
            self.cityId = cityId
            self.districtId = districtId
            self.wardId = wardId
            formTitle = CommonConstants.EDIT_LOCATION
        }
    }
    
    func pickItem(pickerTag: Int) -> String? {
        switch pickerTag{
        case PickerTag.locationType.rawValue:
            if locationType.value.count > 0 {
                return locationType.value[selectedLocationType]
            } else {
                return ""
            }
        case PickerTag.city.rawValue:
            if city.value.count > 0 {
                cityId = city.value[selectedCity].id
                return city.value[selectedCity].name
            } else {
                return ""
            }
        case PickerTag.district.rawValue:
            if district.value.count > 0 {
                districtId = district.value[selectedDistrict].id
                return district.value[selectedDistrict].name
            } else {
                return ""
            }
        case PickerTag.ward.rawValue:
            if ward.value.count > 0 {
                wardId = ward.value[selectedWard].id
                return ward.value[selectedWard].name
            } else {
                return ""
            }
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
