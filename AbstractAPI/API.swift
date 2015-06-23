//
//  API.swift
//  AbstractAPI
//
//  Created by Masaki EBATA on 2015/06/24.
//  Copyright (c) 2015年 Masaki EBATA. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Result

protocol API {
    typealias ResponseType
    typealias ErrorType

    var method: Alamofire.Method { get }
    var pathString: String { get }
    var parameters: [String:AnyObject] { get }
    var responseParser: (AnyObject?, NSError?) -> Result<ResponseType, ErrorType> { get }
}

class APIClient {
    static func sendRequest<T: API where T.ResponseType: Mappable>(API: T, handler: Result<T.ResponseType, T.ErrorType> -> ()) {
        Alamofire.request(API.method, API.pathString, parameters: API.parameters) .responseJSON { (request, response, data, error) in
            handler( API.responseParser(data, error) )
        }
    }
}

class APIs {}