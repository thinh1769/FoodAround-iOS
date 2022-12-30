//
//  LocationService.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 28/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class LocationService: BaseService {
    func addLocation(location: Location) -> Observable<Location> {
        return request(api: .addLocation, params: location)
    }
    
    func getAllLocation() -> Observable<[Location]> {
        return request(api: .getAllLocation)
    }
}
