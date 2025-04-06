//
//  LoginViewButtonModifier.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-05.
//

import SwiftUI

struct LoginViewButtonModifier: ViewModifier {
    
    var isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isDisabled ? Color.gray: Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 20)
    }
}
