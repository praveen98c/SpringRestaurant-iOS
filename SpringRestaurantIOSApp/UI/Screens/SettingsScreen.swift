//
//  SettingsScreen.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation
import SwiftUI

struct SettingsScreen: View {
    
    var authManaging: AuthManagingProtocol
    
    init(authManaging: AuthManagingProtocol) {
        self.authManaging = authManaging
    }
    
    var body: some View {
        Button("Logout", action: {
            Task {
                authManaging.logout()
            }
        })
    }
}
