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
    let queryParameters: [String : [Any]]?
    let bodyType: BodyType? = nil
    
    init(baseURL: String, headers: [String: String], restaurantId: Int64) {
        self.baseURL = baseURL
        self.headers = headers
        queryParameters = nil
        endPoint = HTTPEndPoint(restEndPoint: RestEndPoint.restaurantById.rawValue, pathParameters: ["id": String(restaurantId)])
    }
    
    init(baseURL: String, headers: [String: String], queryParameters: [String : [Any]]?) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
        endPoint = HTTPEndPoint(restEndPoint: RestEndPoint.restaurants.rawValue, pathParameters: nil)
    }
}
