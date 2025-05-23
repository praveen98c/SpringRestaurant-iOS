//
//  LoginRequest.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-03.
//

import Foundation

struct LoginRequest: HTTPRequestProtocol {
    let baseURL: String
    let endPoint: HTTPEndPointProtocol = HTTPEndPoint(restEndPoint: RestEndPoint.login.rawValue)
    let method: HTTPMethod = .POST
    let headers: [String: String]? = nil
    let queryParameters: [String : [Any]]? = nil
    let bodyType: BodyType?
    
    init(baseURL: String, username: String, password: String) {
        self.baseURL = baseURL
        bodyType = .json(["username": username, "password": password])
    }
}
