//
//  HomeScreen.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation
import SwiftUI

struct HomeScreen: View {
    
    var authManaging: AuthManagingProtocol
    
    init(authManaging: AuthManagingProtocol) {
        self.authManaging = authManaging
    }
    
    var body: some View {
        Text("Hello, World!")
        Button("Logout", action: {
            Task {
                authManaging.logout()
            }
        })
    }
}
