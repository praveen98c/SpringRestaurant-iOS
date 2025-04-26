//
//  FoodItemRequest.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

struct FoodItemRequest: HTTPRequestProtocol {
    let baseURL: String
    let endPoint: HTTPEndPointProtocol
    let method: HTTPMethod = .GET
    let headers: [String: String]?
    let queryParameters: [String : [Any]]? = nil
    let bodyType: BodyType? = nil
    
    init(baseURL: String, headers: [String: String], menuId: Int64) {
        self.baseURL = baseURL
        self.headers = headers
        endPoint = HTTPEndPoint(restEndPoint: RestEndPoint.foodItemsByRestaurantId.rawValue, pathParameters: ["id": String(menuId)])
    }
}
