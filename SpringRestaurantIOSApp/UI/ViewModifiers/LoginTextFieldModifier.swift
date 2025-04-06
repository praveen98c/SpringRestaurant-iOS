//
//  LoginTextFieldModifier.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-06.
//

import Foundation
import SwiftUI

struct LoginTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 30)
    }
}

