//
//  RestaurantMapper.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation

extension RestaurantDTO {
    
    func toDomain() -> RestaurantModel {
        return RestaurantModel(
            id: id,
            name: name,
            location: location,
            rating: rating,
            imageUrl: imageUrl
        )
    }
}

extension PageDTO<RestaurantDTO> {
    
    func toDomain() -> [RestaurantModel] {
        return content.map { $0.toDomain() }
    }
}
