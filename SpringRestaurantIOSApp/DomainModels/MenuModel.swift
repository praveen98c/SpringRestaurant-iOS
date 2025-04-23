//
//  MenuModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation

struct MenuModel {
    let id: Int64
    let name: String
    let description: String
}

extension MenuModel: Equatable, Identifiable, Hashable {}
