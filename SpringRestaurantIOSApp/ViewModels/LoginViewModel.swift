//
//  LoginViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation
import Combine

enum LoginViewState {
    case enterCredentials
    case failure(String)
    case loading
}

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var viewState: LoginViewState = .enterCredentials
    @Published var username: String = ""
    @Published var password: String = ""
    
    private let restApiClient: RestApiProtocol
    private let authProtocol: AuthManagingProtocol
    
    init(restApiClient: RestApiProtocol, authProtocol: AuthManagingProtocol) {
        self.restApiClient = restApiClient
        self.authProtocol = authProtocol
    }
    
    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            viewState = .failure("Username or password is empty")
            return
        }
        
        viewState = .loading
        do {
            guard let token = try await restApiClient.login(username: username, password: password) else {
                viewState = .failure("Invalid Credentials")
                return
            }
            
            authProtocol.loginSuccess(token: token)
        } catch {
            viewState = .failure("Login Failed")
        }
    }
}
