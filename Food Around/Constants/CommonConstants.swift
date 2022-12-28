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

struct PickerTag {
    static let LOCATION_TYPE = 0
    static let CITY = 1
    static let DISTRICT = 2
    static let WARD = 3
}

struct FormType {
    static let ADD_NEW_LOCATION_TYPE = 0
    static let EDIT_LOCATION_TYPE = 1
}
