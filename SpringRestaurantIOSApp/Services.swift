//
//  Services.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-14.
//

import Foundation

protocol ServicesProtocol {
    var restaurantService: RestaurantServiceProtocol { get }
    var imageService: ImageServiceProtocol { get }
    var menuService: MenuServiceProtocol { get }
    var foodItemService: FoodItemServiceProtocol { get }
}

struct Services: ServicesProtocol {
    
    let restaurantService: RestaurantServiceProtocol
    let imageService: ImageServiceProtocol
    let menuService: MenuServiceProtocol
    let foodItemService: FoodItemServiceProtocol
    
    init(restApiClient: RestApiProtocol, networkManager: NetworkManager) {
        restaurantService = RestaurantService(restApiClient: restApiClient)
        imageService = ImageService(networkManager: networkManager)
        menuService = MenuService(restApiClient: restApiClient)
        foodItemService = FoodItemService(restApiClient: restApiClient)
    }
}
