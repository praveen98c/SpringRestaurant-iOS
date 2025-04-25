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
    @StateObject var restaurantDetailViewModel: RestaurantDetailViewModel
    @State private var navigationPath = NavigationPath()
    
    init(restaurant: RestaurantModel, menuService: MenuServiceProtocol, imageService: ImageServiceProtocol) {
        self.restaurant = restaurant
        self.imageService = imageService
        _restaurantDetailViewModel = StateObject(wrappedValue: RestaurantDetailViewModel(menuService: menuService))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HorizontalItemScroller(
                title: "Menu Items",
                items: $restaurantDetailViewModel.menus,
                imageService: imageService) { item in }
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
