//
//  FoodItemMapper.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

extension FoodItemDTO {
    
    func toDomain() -> FoodItemModel {
        return FoodItemModel(id: id, name: name, description: description, price: price, rating: rating, cuisine: cuisine.toDomain(), imageUrl: imageUrl)
    }
}

extension CuisineDTO {
    
    func toDomain() -> Cuisine {
        switch self {
        case .english: return .english
        case .chinese: return .chinese
        case .american: return .american
        case .vietnamese: return .vietnamese
        case .moroccan: return .moroccan
        case .french: return .french
        case .thai: return .thai
        case .japanese: return .japanese
        case .greek: return .greek
        case .indian: return .indian
        case .mexican: return .mexican
        case .italian: return .italian
        case .spanish: return .spanish
        case .korean: return .korean
        }
    }
}

extension Array where Element == FoodItemDTO {
    
    func toDomain() -> [FoodItemModel] {
        return map({$0.toDomain()})
    }
}
