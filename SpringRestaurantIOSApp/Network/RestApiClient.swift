//
//  RestApiClient.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

enum RestAPIError: Error {
    case parseError(Error)
}

protocol RestApiProtocol {
    func login(username: String, password: String) async throws -> String?
    func getRestaurantById(id: Int64, token: String) async throws -> RestaurantData
}

enum RestEndPoint: String {
    case login = "/api/auth/login"
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
        let response = try await networkManager.request(request: loginRequest)
        let loginResponse: LoginResponse = try parseResult(response)
        return loginResponse.token
    }
    
    func getRestaurantById(id: Int64, token: String) async throws -> RestaurantData {
        let restaurantRequest = RestaurantRequest(baseURL: baseUrl, headers: authHeader(token: token), restaurantId: id)
        let response = try await networkManager.request(request: restaurantRequest)
        let restaurantResponse: RestaurantResponse = try parseResult(response)
        return restaurantResponse.data
    }
}

fileprivate extension RestApiClient {
    
    func parseResult<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RestAPIError.parseError(error)
        }
    }
    
    func authHeader(token: String) -> [String: String] {
        return ["Authorization": "Bearer \(token)"]
    }
}
