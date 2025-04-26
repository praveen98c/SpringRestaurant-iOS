//
//  FoodItemService.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation

protocol FoodItemServiceProtocol {
    func getFoodItemsByMenuId(id: Int64) async -> Result<[FoodItemModel], RestAPIError>
}

class FoodItemService: FoodItemServiceProtocol {
    
    private let restApiClient: RestApiProtocol
    
    init(restApiClient: RestApiProtocol) {
        self.restApiClient = restApiClient
    }
    
    func getFoodItemsByMenuId(id: Int64) async -> Result<[FoodItemModel], RestAPIError> {
        let result = await restApiClient.getFoodItemsByMenuId(id: id)
        switch result {
        case .success(let foodItems):
            return .success(foodItems.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
}
