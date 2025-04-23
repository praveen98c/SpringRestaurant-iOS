//
//  FeaturedRestaurantsView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation
import SwiftUI

struct FeaturedRestaurantsView: View {
    
    @StateObject var restaurantViewModel: RestaurantViewModel
    @StateObject var imageViewModel: ImageViewModel
    @Binding var navigationPath: NavigationPath
    
    init(restaurantService: RestaurantServiceProtocol, imageService: ImageServiceProtocol, navigationPath: Binding<NavigationPath>) {
        _restaurantViewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantService: FeaturedRestaurantRetrieving(restaurantService: restaurantService)))
        _imageViewModel = StateObject(wrappedValue: ImageViewModel(imageService: imageService))
        _navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Featured Restaurants")
                .modifier(SectionTitleModifier())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurantViewModel.restaurants, id: \.id) { restaurant in
                        Button(action: {
                            navigationPath.append(restaurant)
                        }) {
                            FeaturedRestaurantCardView(restaurant: restaurant, homeViewModel: restaurantViewModel, imageViewModel: imageViewModel)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onAppear {
            restaurantViewModel.loadMoreIfNeeded(index: 0)
        }
    }
}
