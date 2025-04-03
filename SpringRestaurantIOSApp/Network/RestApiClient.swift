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
}

enum RestEndPoint: String {
    case login = "/api/auth/login"
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
}

fileprivate extension RestApiClient {
    
    func parseResult<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RestAPIError.parseError(error)
        }
    }
}
