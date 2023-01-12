//
//  DetailPopupViewModel.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 11/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

class DetailPopupViewModel {
    let bag = DisposeBag()
    let locationService = LocationService()
    var locationDetail: Location?
    
    func getLocationById(_ id: String) -> Observable<Location> {
        return locationService.getLocationById(locationId: id)
    }
}
