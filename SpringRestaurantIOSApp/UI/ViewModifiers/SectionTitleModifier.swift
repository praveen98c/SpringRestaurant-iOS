//
//  TitleModifier.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation
import SwiftUI

struct SectionTitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .bold()
            .padding([.top, .horizontal])
    }
}
