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
    let appContext: AppContext
    
    init(appContext: AppContext, authManaging: AuthManagingProtocol) {
        self.authManaging = authManaging
        self.appContext = appContext
    }
    
    var body: some View {
        TabView {
            RestaurantsScreen(appContext: appContext)
                .tabItem {
                    Label("Restaurants", systemImage: "house")
                }
            SettingsScreen(authManaging: authManaging)
                .tabItem {
                    Label("Settings", systemImage: "magnifyingglass")
                }
        }
    }
}
