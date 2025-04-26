//
//  RestaurantResponse.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-03.
//

import Foundation

struct RestaurantDTO: Codable {
    let id: Int64
    let name: String
    let location: String
    let rating: Double
    let imageUrl: String
}
