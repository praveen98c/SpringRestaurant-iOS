//
//  RestaurantService.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-14.
//

import Foundation

protocol RestaurantServiceProtocol {
    func getRestaurants(page: Int, size: Int) async -> Result<[RestaurantModel], RestAPIError>
}

class RestaurantService: RestaurantServiceProtocol {
    
    private let restApiClient: RestApiProtocol
    
    init(restApiClient: RestApiProtocol) {
        self.restApiClient = restApiClient
    }
    
    func getRestaurants(page: Int, size: Int) async -> Result<[RestaurantModel], RestAPIError> {
        let result = await restApiClient.getRestaurants(page: page, size: size)
        switch result {
        case .success(let restaurants):
            return .success(restaurants.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
}
