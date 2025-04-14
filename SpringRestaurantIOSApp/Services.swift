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
}

struct Services: ServicesProtocol {
    
    let restaurantService: RestaurantServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(restApiClient: RestApiProtocol, networkManager: NetworkManager) {
        self.restaurantService = RestaurantService(restApiClient: restApiClient)
        self.imageService = ImageService(networkManager: networkManager)
    }
}
