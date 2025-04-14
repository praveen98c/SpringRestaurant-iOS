//
//  HomeView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-12.
//

import Foundation
import SwiftUI

struct RestaurantsView: View {
    
    @StateObject var restaurantViewModel: RestaurantViewModel
    @Binding var navigationPath: NavigationPath
    
    init(appContext: AppContext, navigationPath: Binding<NavigationPath>) {
        _restaurantViewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantService: RestaurantRetrieving(restaurantService: appContext.services.restaurantService), imageService: appContext.services.imageService))
        _navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("All Restaurants")
                .modifier(SectionTitleModifier())
            List(Array(restaurantViewModel.restaurants.enumerated()), id: \.element.id) { index, restaurant in
                Button(action: {
                    navigationPath.append(restaurant)
                }) {
                    RestaurantTile(restaurant: restaurant, homeViewModel: restaurantViewModel)
                        .onAppear {
                            restaurantViewModel.loadMoreIfNeeded(index: index)
                        }
                        .contentShape(Rectangle())
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            restaurantViewModel.loadMoreIfNeeded(index: 0)
        }
    }
}

struct RestaurantDetailView: View {
    
    let restaurant: RestaurantModel
    
    var body: some View {
        Text("\(restaurant.name)")
    }
}
