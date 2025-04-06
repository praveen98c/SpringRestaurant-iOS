//
//  Untitled.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Combine

enum AuthState {
    case checking
    case authenticated
    case notAuthenticated
}

protocol AuthManagingProtocol {
    func loginSuccess()
    func logout()
}

class AuthViewModel: ObservableObject, AuthManagingProtocol {
    @Published var authState: AuthState = .checking

    private var keyChainValues: KeyChainValuesProtocol
    private let jwtHelper: JWTHelperProtocol
    
    init(keyChainValues: KeyChainValuesProtocol, jwtHelper: JWTHelperProtocol) {
        self.keyChainValues = keyChainValues
        self.jwtHelper = jwtHelper
    }
    
    func verifyToken() {
        guard let authToken = keyChainValues.authToken else {
            authState = .notAuthenticated
            return
        }
        
        if jwtHelper.isTokenExpired(token: authToken) {
            keyChainValues.authToken = ""
            authState = .notAuthenticated
        } else {
            authState = .authenticated
        }
    }
    
    func loginSuccess() {
        authState = .authenticated
    }
    
    func logout() {
        keyChainValues.authToken = nil
        authState = .notAuthenticated
    }
}
