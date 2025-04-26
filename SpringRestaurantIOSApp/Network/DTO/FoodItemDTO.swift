//
//  FoodItemDTO.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

struct FoodItemDTO: Decodable {
    let id: Int64
    let name: String
    let description: String
    let price: Double
    let rating: Double
    let cuisine: CuisineDTO
    let imageUrl: String
}

enum CuisineDTO: String, Decodable {
    case english
    case chinese
    case american
    case vietnamese
    case moroccan
    case french
    case thai
    case japanese
    case greek
    case indian
    case mexican
    case italian
    case spanish
    case korean
}
