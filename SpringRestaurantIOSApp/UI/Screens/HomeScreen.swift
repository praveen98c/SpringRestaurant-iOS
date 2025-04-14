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
    @StateObject var viewModel = HomeViewModel()
    
    init(appContext: AppContext, authManaging: AuthManagingProtocol) {
        self.authManaging = authManaging
        self.appContext = appContext
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 0) {
                FeaturedRestaurantsView(appContext: appContext, navigationPath: $viewModel.navigationPath)
                RestaurantsView(appContext: appContext, navigationPath: $viewModel.navigationPath)
                Button("Logout", action: {
                    Task {
                        authManaging.logout()
                    }
                })
            }
        }
        .navigationDestination(for: RestaurantModel.self) { restaurant in
            RestaurantDetailView(restaurant: restaurant)
        }
    }
}
