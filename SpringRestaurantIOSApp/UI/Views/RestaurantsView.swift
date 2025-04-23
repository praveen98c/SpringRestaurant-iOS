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
    @StateObject var imageViewModel: ImageViewModel
    @Binding var navigationPath: NavigationPath
    
    init(restaurantService: RestaurantServiceProtocol, imageService: ImageServiceProtocol, navigationPath: Binding<NavigationPath>) {
        _restaurantViewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantService: RestaurantRetrieving(restaurantService: restaurantService)))
        _imageViewModel = StateObject(wrappedValue: ImageViewModel(imageService: imageService))
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
                    RestaurantTile(restaurant: restaurant, homeViewModel: restaurantViewModel, imageViewModel: imageViewModel)
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
