//
//  RestApiClient.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

protocol RestApiProtocol {
    func login(username: String, password: String) async -> Result<LoginDTO, RestAPIError>
    func register(username: String, password: String, name: String) async -> Result<Void, RestAPIError>
    func getRestaurantById(id: Int64) async -> Result<RestaurantDTO, RestAPIError>
    func getRestaurants(page: Int, size: Int) async -> Result<PageDTO<RestaurantDTO>, RestAPIError>
    func getMenusByRestaurantId(id: Int64) async -> Result<[MenuDTO], RestAPIError>
    func getFoodItemsByMenuId(id: Int64) async -> Result<[FoodItemDTO], RestAPIError>
}

enum RestEndPoint: String {
    case login = "/api/auth/login"
    case register = "/api/auth/register"
    case restaurantById = "/api/restaurants/{id}"
    case restaurants = "/api/restaurants"
    case menusByRestaurantId = "/api/menus/restaurant/{id}"
    case foodItemsByRestaurantId = "/api/fooditems/menu/{id}"
}

final class RestApiClient: RestApiProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let baseUrl: String
    private var keyChainValues: KeyChainValuesProtocol
    
    init(networkManager: NetworkManagerProtocol, baseUrl: String, keyChainValues: KeyChainValuesProtocol) {
        self.networkManager = networkManager
        self.baseUrl = baseUrl
        self.keyChainValues = keyChainValues
    }
    
    func login(username: String, password: String) async -> Result<LoginDTO, RestAPIError> {
        let loginRequest = LoginRequest(baseURL: baseUrl, username: username, password: password)
        let response = await networkManager.request(request: loginRequest)
        let loginResponse: Result<LoginDTO, RestAPIError> = parseResult(response)
        switch loginResponse {
        case .success(let loginResponseObject):
            keyChainValues.authToken = loginResponseObject.token
        case .failure(_):
            break
        }
        return loginResponse
    }
    
    func register(username: String, password: String, name: String) async -> Result<Void, RestAPIError> {
        let registerRequest = RegisterRequest(baseURL: baseUrl, username: username, password: password, name: name)
        let response = await networkManager.request(request: registerRequest)
        return parseVoidResult(response)
    }
    
    func getRestaurantById(id: Int64) async -> Result<RestaurantDTO, RestAPIError> {
        guard let token = keyChainValues.authToken else { fatalError() }
        let restaurantRequest = RestaurantRequest(baseURL: baseUrl, headers: authHeader(token: token), restaurantId: id)
        let response = await networkManager.request(request: restaurantRequest)
        return parseResult(response)
    }
    
    func getRestaurants(page: Int, size: Int) async -> Result<PageDTO<RestaurantDTO>, RestAPIError> {
        guard let token = keyChainValues.authToken else { fatalError() }
        let restaurantRequest = RestaurantRequest(baseURL: baseUrl, headers: authHeader(token: token), queryParameters: ["page": [page], "size": [size]])
        let response = await networkManager.request(request: restaurantRequest)
        return parseResult(response)
    }
    
    func getMenusByRestaurantId(id: Int64) async -> Result<[MenuDTO], RestAPIError> {
        guard let token = keyChainValues.authToken else { fatalError() }
        let menuRequest = MenuRequest(baseURL: baseUrl, headers: authHeader(token: token), restaurantId: id)
        let response = await networkManager.request(request: menuRequest)
        return parseResult(response)
    }
    
    func getFoodItemsByMenuId(id: Int64) async -> Result<[FoodItemDTO], RestAPIError> {
        guard let token = keyChainValues.authToken else { fatalError() }
        let menuRequest = FoodItemRequest(baseURL: baseUrl, headers: authHeader(token: token), menuId: id)
        let response = await networkManager.request(request: menuRequest)
        return parseResult(response)
    }
}

fileprivate extension RestApiClient {
    
    func parseVoidResult(_ result: Result<Data, NetworkErrorData>) -> Result<Void, RestAPIError> {
        switch result {
        case .success(_):
            return .success(())
        case .failure(let networkError):
            do {
                try handleFailure(networkError: networkError)
            } catch {
                return .failure(error)
            }
        }
    }
    
    func parseResult<T: Decodable>(_ result: Result<Data, NetworkErrorData>) -> Result<T, RestAPIError> {
        do {
            switch result {
            case .success(let data):
                let decoded: T = try parse(data: data)
                return .success(decoded)
            case .failure(let networkError):
                try handleFailure(networkError: networkError)
            }
        } catch {
            return .failure(error)
        }
    }
    
    private func parse<T: Decodable>(data: Data) throws(RestAPIError) -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw .parseError(error)
        }
    }
    
    private func handleFailure(networkError: NetworkErrorData) throws(RestAPIError) -> Never {
        guard
            let data = networkError.data,
            !data.isEmpty
        else {
            throw .networkError(networkError.error)
        }
        
        let apiResponse: ApiResponse = try parse(data: data)
        let message = apiResponse.message
        let code = apiResponse.code
        throw RestAPIError.apiError(message, code)
    }
    
    func authHeader(token: String) -> [String: String] {
        return ["Authorization": "Bearer \(token)"]
    }
}

enum RestAPIError: Error {
    case apiError(String, Int)
    case networkError(NetworkError)
    case parseError(Error)
}
