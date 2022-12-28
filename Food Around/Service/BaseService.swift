//
//  BaseService.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 27/12/2022.
//

import Foundation
import Alamofire
import RxSwift

class BaseService: NSObject {
    var baseHeader = HTTPHeaders()
    override init() {
        baseHeader.add(HTTPHeader(name: "token", value: "Bearer " + (UserDefaults.userInfo?.token ?? "")))
    }
    
    func authRequest<Body: Codable, Response: Codable>(api: APIConstants, method: HTTPMethod, parameters: Body, headers: [String: String]? = nil) -> Observable<Response> {
        let url = Base.URL + api.rawValue
        if headers != nil {
            for header in headers! {
                baseHeader.add(name: header.key, value: header.value)
            }
        }
        let request = AF.request(url, method: method, parameters: parameters, encoder: .json, headers: self.baseHeader)
        return performRequest(request)
    }
    
    func authRequest<Response: Codable>(api: APIConstants, method: HTTPMethod, headers: [String: String]? = nil) -> Observable<Response> {
        let url = Base.URL + api.rawValue
        if headers != nil {
            for header in headers! {
                baseHeader.add(name: header.key, value: header.value)
            }
        }
        let request = AF.request(url, method: method, headers: self.baseHeader)
        return performRequest(request)
    }
        
    private func performRequest<Response: Codable>(_ request: DataRequest) -> Observable<Response> {
        return Observable.create { observer in
            request.responseDecodable(of: ResponseMain<Response>.self) { response in
                var error: String? = nil
                if let data = response.value {
                    switch data.statusCode {
                    case StatusCode.OK:
                        if let payload = data.payload {
                            observer.onNext(payload)
                        }
                        observer.onCompleted()
                    case StatusCode.BAD_REQUEST:
                        error = data.message
                    case StatusCode.UNAUTHORIZED:
                        error = data.message
                    case StatusCode.SERVER_ERROR:
                        error = data.message
                    default:
                        error = data.message
                    }
                }
                if let er = error {
                    print("Error : \(er)")
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
