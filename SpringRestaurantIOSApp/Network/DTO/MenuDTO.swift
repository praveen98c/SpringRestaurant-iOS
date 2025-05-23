//
//  MenuDTO.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation

struct MenuDTO: Codable {
    let id: Int64
    let name: String
    let description: String
    let rating: Double
    let imageUrl: String
}
