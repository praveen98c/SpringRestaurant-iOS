//
//  FoodItemsView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation
import SwiftUI

struct FoodItemsView: View {
    
    @StateObject private var viewModel: FoodItemsViewModel
    @StateObject private var imageViewModel: ImageViewModel
    private let menu: MenuModel
    
    init(foodItemService: FoodItemServiceProtocol, imageService: ImageServiceProtocol, menu: MenuModel) {
        _viewModel = StateObject(wrappedValue: FoodItemsViewModel(foodItemService: foodItemService))
        _imageViewModel = StateObject(wrappedValue: ImageViewModel(imageService: imageService))
        self.menu = menu
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Food Items \(menu.name)")
                .modifier(SectionTitleModifier())
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.foodItems, id: \.self) { item in
                        ItemCardView(item: item, imageViewModel: imageViewModel)
                    }
                }
                .padding()
            }
        }.onAppear {
            viewModel.loadFoodItems(menuId: menu.id)
        }.onChange(of: menu.id) { oldValue, newValue in
            viewModel.loadFoodItems(menuId: newValue)
        }
    }
}

extension FoodItemModel: ItemProtocol {
    var title: String {
        return name
    }
}
