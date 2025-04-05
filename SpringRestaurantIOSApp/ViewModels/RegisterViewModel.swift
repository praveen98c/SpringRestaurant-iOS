//
//  RegisterViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-04.
//

import Foundation
import SwiftUI

enum RegisterViewState {
    case enterInfo
    case failure(String)
    case loading
    case success
}

@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var viewState: RegisterViewState = .enterInfo
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    
    private let restApiClient: RestApiProtocol
    private let authProtocol: AuthManagingProtocol
    
    init(restApiClient: RestApiProtocol, authProtocol: AuthManagingProtocol) {
        self.restApiClient = restApiClient
        self.authProtocol = authProtocol
    }
    
    func register() async {
        guard !username.isEmpty, !password.isEmpty, !name.isEmpty else {
            viewState = .failure("Username, password or name is empty")
            return
        }
        
        viewState = .loading
        do {
            try await restApiClient.register(username: username, password: password, name: name)
            viewState = .success
        } catch let error as RestAPIError {
            let message: String
            switch error {
            case .apiError(let msg, _):
                message = msg
            case .parseError(_):
                message = "internal error"
            }
            
            viewState = .failure(message)
        } catch {
            
        }
    }
}
