//
//  ScrollItem.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

protocol ItemProtocol: Hashable {
    var id: Int64 { get }
    var title: String { get }
    var imageUrl: String { get }
}
