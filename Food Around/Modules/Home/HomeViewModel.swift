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
    
    func getAllLocation() -> Observable<[Location]> {
        return locationService.getAllLocation()
    }
    
}
