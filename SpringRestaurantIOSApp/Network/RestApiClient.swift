//
//  RestApiClient.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

protocol RestApiProtocol {
    func login(username: String, password: String) async throws -> String?
    func register(username: String, password: String, name: String) async throws
    func getRestaurantById(id: Int64, token: String) async throws -> RestaurantData
}

enum RestEndPoint: String {
    case login = "/api/auth/login"
    case register = "/api/auth/register"
    case restaurants = "/api/restaurants/{id}"
}

final class RestApiClient: RestApiProtocol {
    
    let networkManager: NetworkManagerProtocol
    let baseUrl: String
    
    init(networkManager: NetworkManagerProtocol, baseUrl: String) {
        self.networkManager = networkManager
        self.baseUrl = baseUrl
    }
    
    func login(username: String, password: String) async throws -> String? {
        let loginRequest = LoginRequest(baseURL: baseUrl, username: username, password: password)
        let response = await networkManager.request(request: loginRequest)
        let loginResponse: LoginResponse = try parseResult(response)
        return loginResponse.token
    }
    
    func register(username: String, password: String, name: String) async throws {
        let registerRequest = RegisterRequest(baseURL: baseUrl, username: username, password: password, name: name)
        let response = await networkManager.request(request: registerRequest)
        let _: ApiResponse = try parseResult(response)
    }
    
    func getRestaurantById(id: Int64, token: String) async throws -> RestaurantData {
        let restaurantRequest = RestaurantRequest(baseURL: baseUrl, headers: authHeader(token: token), restaurantId: id)
        let response = await networkManager.request(request: restaurantRequest)
        let restaurantResponse: RestaurantResponse = try parseResult(response)
        return restaurantResponse.data
    }
}

fileprivate extension RestApiClient {
    
    func parseResult<T: Decodable>(_ result: Result<Data, NetworkErrorData>) throws -> T {
        do {
            switch result {
            case .success(let data):
                return try JSONDecoder().decode(T.self, from: data)
            case .failure(let networkError):
                var apiResponse: ApiResponse? = nil
                if let data = networkError.data {
                    apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                }
                
                let message = apiResponse?.message ?? "Unknown error"
                let code = apiResponse?.code ?? -999
                throw RestAPIError.apiError(message, code)
            }
        } catch {
            throw error
        }
    }
    
    func authHeader(token: String) -> [String: String] {
        return ["Authorization": "Bearer \(token)"]
    }
}

enum RestAPIError: Error {
    case apiError(String, Int)
    case parseError(Error)
}
