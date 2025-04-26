//
//  FoodItemsViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

class FoodItemsViewModel: ObservableObject {
    
    @Published var foodItems: [FoodItemModel] = []
    let foodItemService: FoodItemServiceProtocol
    
    init(foodItemService: FoodItemServiceProtocol) {
        self.foodItemService = foodItemService
    }
    
    func loadFoodItems(menuId: Int64) {
        Task {
            let result = await foodItemService.getFoodItemsByMenuId(id: menuId)
            switch result {
            case .success(let foodItems):
                await updateFoodItems(foodItems)
            case .failure(let error):
                break
                // handle error
            }
        }
    }
    
    @MainActor
    func updateFoodItems(_ foodItems: [FoodItemModel]) {
        self.foodItems = foodItems
    }
}
