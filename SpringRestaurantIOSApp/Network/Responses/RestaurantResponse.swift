//
//  RestaurantResponse.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-03.
//

import Foundation

struct RestaurantData: Codable {
    let id: Int64
    let name: String
    let location: String
}

struct RestaurantResponse : Codable {
    let data: RestaurantData
    let message: String
}
