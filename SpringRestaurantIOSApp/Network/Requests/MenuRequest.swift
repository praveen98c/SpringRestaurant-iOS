//
//  MenuRequest.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-23.
//

import Foundation

struct MenuRequest: HTTPRequestProtocol {
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
        endPoint = HTTPEndPoint(restEndPoint: RestEndPoint.menusByRestaurantId.rawValue, pathParameters: ["id": String(restaurantId)])
    }
}
