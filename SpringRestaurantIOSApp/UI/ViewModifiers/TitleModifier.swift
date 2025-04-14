//
//  TitleModifier.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation
import SwiftUI

struct TitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(2)
    }
}
