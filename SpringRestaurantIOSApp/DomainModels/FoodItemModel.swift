//
//  FoodItemModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

struct FoodItemModel {
    let id: Int64
    let name: String
    let description: String
    let price: Double
    let rating: Double
    let cuisine: Cuisine
    let imageUrl: String
}

enum Cuisine: String, Decodable {
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

extension FoodItemModel: Equatable, Identifiable, Hashable {}
