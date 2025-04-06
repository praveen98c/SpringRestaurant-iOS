//
//  AppContext.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

struct AppContext {
    let restApiClient: RestApiProtocol
    let keychainValues: KeyChainValuesProtocol = KeyChainValues()
    let jwtHelper: JWTHelperProtocol = JWTHelper()
    
    init() {
        restApiClient = RestApiClient(networkManager: NetworkManager(), baseUrl: "http://127.0.0.1:8081", keyChainValues: keychainValues)
    }
}
