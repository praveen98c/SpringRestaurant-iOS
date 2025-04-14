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
    @Binding var navigationPath: NavigationPath
    
    init(appContext: AppContext, navigationPath: Binding<NavigationPath>) {
        _restaurantViewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantService: FeaturedRestaurantRetrieving(restaurantService: appContext.services.restaurantService), imageService: appContext.services.imageService))
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
                            FeaturedRestaurantCardView(restaurant: restaurant, homeViewModel: restaurantViewModel)
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
