//
//  HomeViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-12.
//

import Foundation
import SwiftUI

class RestaurantViewModel: ObservableObject {
    
    @Published private(set) var restaurants: [RestaurantModel] = []
    private var pageNumber = 0
    private var pageSize = 10
    private var ongoingTasks: [String: Task<(), Never>] = [:]
    private let restaurantService: RestaurantRetrievingProtocol
    
    init(restaurantService: RestaurantRetrievingProtocol) {
        self.restaurantService = restaurantService
    }
    
    func loadMoreIfNeeded(index: Int) {
        guard index >= restaurants.count - 2 else { return }
        let taskId = "\(pageNumber)\(pageSize)"
        if let _ = ongoingTasks[taskId] {
            return
        }
        
        let task = Task {
            defer { ongoingTasks[taskId] = nil }
            let result = await restaurantService.getRestaurants(page: pageNumber, size: pageSize)
            switch result {
            case .success(let restaurants):
                pageNumber += 1
                await updateRestaurants(restaurants: restaurants)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        ongoingTasks[taskId] = task
    }
}

private extension RestaurantViewModel {
    
    @MainActor
    func updateRestaurants(restaurants: [RestaurantModel]) {
        self.restaurants.append(contentsOf: restaurants)
    }
}

protocol RestaurantRetrievingProtocol {
    func getRestaurants(page: Int, size: Int) async -> Result<[RestaurantModel], RestAPIError>
}

struct RestaurantRetrieving: RestaurantRetrievingProtocol {

    let restaurantService: RestaurantServiceProtocol
    
    init(restaurantService: RestaurantServiceProtocol) {
        self.restaurantService = restaurantService
    }
    
    func getRestaurants(page: Int, size: Int) async -> Result<[RestaurantModel], RestAPIError> {
        await restaurantService.getRestaurants(page: page, size: size)
    }
}

struct FeaturedRestaurantRetrieving: RestaurantRetrievingProtocol {

    let restaurantService: RestaurantServiceProtocol
    
    init(restaurantService: RestaurantServiceProtocol) {
        self.restaurantService = restaurantService
    }
    
    func getRestaurants(page: Int, size: Int) async -> Result<[RestaurantModel], RestAPIError> {
        // TODO: Call the featured restaurants
        await restaurantService.getRestaurants(page: page, size: size)
    }
}
