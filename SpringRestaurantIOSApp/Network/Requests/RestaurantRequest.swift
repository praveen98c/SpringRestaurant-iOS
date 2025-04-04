//
//  RestaurantRequest.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-03.
//

import Foundation

struct RestaurantRequest: HTTPRequestProtocol {
    let baseURL: String
    let endPoint: HTTPEndPointProtocol
    let method: HTTPMethod = .GET
    let headers: [String: String]?
    let queryParameters: [String : [Any]]? = nil
    let bodyType: BodyType? = nil
    
    init(baseURL: String, headers: [String: String], restaurantId: Int64) {
        self.baseURL = baseURL
        self.headers = headers
        endPoint = RestaurantEndPoint(pathParameters: ["id": String(restaurantId)])
    }
}

struct RestaurantEndPoint: HTTPEndPointProtocol {
    let restEndPoint: String = RestEndPoint.restaurants.rawValue
    let pathParameters: [String : String]?
}
