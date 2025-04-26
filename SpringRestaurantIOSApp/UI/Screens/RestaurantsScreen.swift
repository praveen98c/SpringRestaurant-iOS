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
    @StateObject var featuredRestaurantsViewModel: RestaurantViewModel
    
    init(appContext: AppContext) {
        self.appContext = appContext
        _featuredRestaurantsViewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantService: FeaturedRestaurantRetrieving(restaurantService: appContext.services.restaurantService)))
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 0) {
                HorizontalItemScroller(title: "Featured Restaurants",
                                       items: featuredRestaurantsViewModel.bindingForRestaurants(),
                                       imageService: appContext.services.imageService) { item in
                    viewModel.navigateTo(item)
                }.onAppear() {
                    featuredRestaurantsViewModel.loadMoreIfNeeded(index: 0)
                }
                RestaurantsView(restaurantService: appContext.services.restaurantService,
                                imageService: appContext.services.imageService,
                                navigationPath: $viewModel.navigationPath)
            }
            .navigationDestination(for: RestaurantModel.self) { restaurant in
                RestaurantDetailView(restaurant: restaurant,
                                     menuService: appContext.services.menuService,
                                     foodItemService: appContext.services.foodItemService,
                                     imageService: appContext.services.imageService)
            }
        }
    }
}

extension RestaurantModel: ItemProtocol {
    var title: String { name }
    var imageURL: String { imageUrl }
}
