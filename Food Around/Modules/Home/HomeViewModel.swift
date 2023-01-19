//
//  HomeViewModel.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 23/12/2022.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
    let bag = DisposeBag()
    let locationService = LocationService()
    var location = BehaviorRelay<[Location]>(value: [])
    var searchedLocation = BehaviorRelay<[Location]>(value: [])
    
    func getAllLocation() -> Observable<[Location]> {
        return locationService.getAllLocation()
    }
    
    func findLocation(searchString: String) -> Observable<[Location]> {
        return locationService.findLocation(searchString: searchString)
    }
}
