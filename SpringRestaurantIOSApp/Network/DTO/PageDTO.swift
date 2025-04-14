//
//  PageDTO.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-15.
//

import Foundation

struct PageDTO<T: Codable>: Codable {
    let content: [T]
    let totalPages: Int
    let totalElements: Int
}
