//
//  RestaurantModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation

struct RestaurantModel {
    let id: Int64
    let name: String
    let location: String
    let imageUrl: String
}

extension RestaurantModel: Equatable, Identifiable, Hashable {}
