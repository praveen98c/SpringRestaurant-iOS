//
//  RegisterRequest.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-04.
//

import Foundation

struct RegisterRequest: HTTPRequestProtocol {
    let baseURL: String
    let endPoint: HTTPEndPointProtocol = HTTPEndPoint(restEndPoint: RestEndPoint.register.rawValue)
    let method: HTTPMethod = .POST
    let headers: [String: String]? = nil
    let queryParameters: [String : [Any]]? = nil
    let bodyType: BodyType?
    
    init(baseURL: String, username: String, password: String, name: String) {
        self.baseURL = baseURL
        bodyType = .json(["username": username, "password": password, "name": name])
    }
}
