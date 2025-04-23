//
//  MenuMapper.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation

extension MenuDTO {
    
    func toDomain() -> MenuModel {
        return MenuModel(name: name, description: description)
    }
}

extension Array where Element == MenuDTO {
    
    func toDomain() -> [MenuModel] {
        return map({$0.toDomain()})
    }
}
