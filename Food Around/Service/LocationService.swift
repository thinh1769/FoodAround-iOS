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
    
    func updateLocation(location: Location) -> Observable<Location> {
        return request(api: APIConstants.updateLocation.rawValue + (location.id ?? ""), method: .put, params: location)
    }
    
    func deleleLocation(locationId: String) -> Observable<Location> {
        return request(api: APIConstants.deleteLocation.rawValue + locationId, method: .delete)
    }
    
    func getAllLocation() -> Observable<[Location]> {
        return request(api: .getAllLocation)
    }
    
    func getLocationById(locationId: String) -> Observable<Location> {
        return request(api: APIConstants.getLocationById.rawValue + locationId, method: .get)
    }
    
    func findLocation(searchString: String) -> Observable<[Location]> {
        let param = ["searchString": searchString]
        return request(api: APIConstants.findLocation.rawValue, method: .post, params: param)
    }
}
