//
//  RestaurantDetailView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-23.
//

import Foundation
import SwiftUI

struct RestaurantDetailView: View {
    
    let restaurant: RestaurantModel
    @StateObject var restaurantDetailViewModel: RestaurantDetailViewModel
    
    init(restaurant: RestaurantModel, menuService: MenuServiceProtocol) {
        self.restaurant = restaurant
        _restaurantDetailViewModel = StateObject(wrappedValue: RestaurantDetailViewModel(menuService: menuService))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Menu Items")
                .modifier(SectionTitleModifier())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurantDetailViewModel.menus, id: \.id) { menu in
                        Button(action: {
                            //                            navigationPath.append(restaurant)
                        }) {
                            Text(menu.name)
                            //                            FeaturedRestaurantCardView(restaurant: restaurant, homeViewModel: restaurantViewModel)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onAppear {
            restaurantDetailViewModel.loadMenus(restaurantId: restaurant.id)
        }
    }
}
