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
    @Published var loadedImages: [URL: UIImage?] = [:]
    
    private let maxSize = CGSize(width: 100, height: 100)
    private var pageNumber = 0
    private var pageSize = 10
    private var ongoingTasks: [String: Task<(), Never>] = [:]
    private var ongoingImageFetchingTasks: [URL: Task<(), Never>] = [:]
    private let restaurantService: RestaurantRetrievingProtocol
    private let imageService: ImageServiceProtocol
    
    init(restaurantService: RestaurantRetrievingProtocol, imageService: ImageServiceProtocol) {
        self.restaurantService = restaurantService
        self.imageService = imageService
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
    
    func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if let _ = ongoingImageFetchingTasks[url] {
            return
        }
        
        let task = Task { [weak self] in
            guard let self = self else { return }
            defer { ongoingImageFetchingTasks[url] = nil }
            do {
                guard let image = try await imageService.fetchImage(from: url, maxSize: maxSize) else {
                    return
                }
                
                await updateImage(url: url, image: image)
            } catch {
                print("Image download error for \(urlString): \(error)")
            }
        }
        
        ongoingImageFetchingTasks[url] = task
    }
    
    func cancelDownloadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadedImages[url] = nil
        if let existingTask = ongoingImageFetchingTasks[url] {
            existingTask.cancel()
        }
    }
}

private extension RestaurantViewModel {
    
    @MainActor
    func updateImage(url: URL, image: UIImage) {
        loadedImages[url] = image
    }
    
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
