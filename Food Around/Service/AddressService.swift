//
//  AddressService.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 29/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class AddressService: BaseService {
    func getAllCities() -> Observable<[City]> {
        request(api: .getAllCities)
    }
    
    func getDistrictsByCityId(cityId: String) -> Observable<[District]> {
        return request(api: APIConstants.getDistrictsByCityId.rawValue + cityId, method: .get)
    }
    
    func getWardsByDistrictId(districtId: String) -> Observable<[Ward]> {
        return request(api: APIConstants.getWardsByDistrictId.rawValue + districtId, method: .get)
    }
}
