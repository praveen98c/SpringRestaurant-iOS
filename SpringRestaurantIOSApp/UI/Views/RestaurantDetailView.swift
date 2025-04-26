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
    private let imageService: ImageServiceProtocol
    private let foodItemService: FoodItemServiceProtocol
    @StateObject var restaurantDetailViewModel: RestaurantDetailViewModel
    
    init(restaurant: RestaurantModel,
         menuService: MenuServiceProtocol,
         foodItemService: FoodItemServiceProtocol,
         imageService: ImageServiceProtocol) {
        self.restaurant = restaurant
        self.imageService = imageService
        self.foodItemService = foodItemService
        _restaurantDetailViewModel = StateObject(wrappedValue: RestaurantDetailViewModel(menuService: menuService))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HorizontalItemScroller(
                title: "Menu Items",
                items: $restaurantDetailViewModel.menus,
                imageService: imageService) { item in
                    restaurantDetailViewModel.selectedMenu = item
                }
            if let menu = restaurantDetailViewModel.selectedMenu {
                FoodItemsView(foodItemService: foodItemService, imageService: imageService, menu: menu)
            } else {
                Spacer()
            }
        }
        .padding(.vertical)
        .onAppear {
            restaurantDetailViewModel.loadMenus(restaurantId: restaurant.id)
        }
    }
}

extension MenuModel: ItemProtocol {
    var title: String { name }
}
