//
//  MenuMapper.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation

extension MenuDTO {
    
    func toDomain() -> MenuModel {
        return MenuModel(id: id, name: name, description: description, imageUrl: imageUrl)
    }
}

extension Array where Element == MenuDTO {
    
    func toDomain() -> [MenuModel] {
        return map({$0.toDomain()})
    }
}
