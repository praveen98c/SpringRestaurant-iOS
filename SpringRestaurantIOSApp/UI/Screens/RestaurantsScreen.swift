//
//  RestaurantsScreen.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation
import SwiftUI

struct RestaurantsScreen: View {
    
    let appContext: AppContext
    @StateObject var viewModel = RestaurantScreenViewModel()
    
    init(appContext: AppContext) {
        self.appContext = appContext
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 0) {
                FeaturedRestaurantsView(restaurantService: appContext.services.restaurantService,
                                        imageService: appContext.services.imageService,
                                        navigationPath: $viewModel.navigationPath)
                RestaurantsView(restaurantService: appContext.services.restaurantService,
                                imageService: appContext.services.imageService,
                                navigationPath: $viewModel.navigationPath)
            }
            .navigationDestination(for: RestaurantModel.self) { restaurant in
                RestaurantDetailView(restaurant: restaurant, menuService: appContext.services.menuService)
            }
        }
    }
}
