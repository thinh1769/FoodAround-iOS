//
//  File.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 21/12/2022.
//

import Foundation

struct CommonConstants {
    static let LOCATION_TYPE = ["Món bò", "Món nước", "Món khô", "Món hấp", "Món nướng", "Món lẩu", "Món chiên", "Món ăn vặt", "Cà phê", "Trà sữa"]
    static let DONE = "Xong"
    static let CANCEL = "Thoát"
    static let LOCATION_TYPE_PLACEHOLDER = "Loại địa điểm"
    static let CITY_PLACEHOLDER = "Tỉnh, thành phố"
    static let DISTRICT_PLACEHOLDER = "Quận, huyện"
    static let WARD_PLACEHOLDER = "Phường, xã"
    static let ADD_NEW_LOCATION = "Thêm Địa Điểm Mới"
    static let EDIT_LOCATION = "Sửa Địa Điểm"
}

enum PickerTag: Int {
    case locationType
    case city
    case district
    case ward
}

enum FormType: Int {
    case add
    case edit
}

enum SubviewTag: Int {
    case otherView
    case detailView
}

enum LocationTitle: String {
    case userLocation
    case location
}
