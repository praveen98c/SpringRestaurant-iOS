//
//  LoginViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation
import Combine

enum LoginViewFeedbackState {
    case none
    case failure(String)
    case networkRequestInProgress
    
    var isNetworkRequestInProgress: Bool {
        if case .networkRequestInProgress = self {
            return true
        } else {
            return false
        }
    }
}

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var viewState: LoginViewFeedbackState = .none
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
        
        viewState = .networkRequestInProgress
        let result = await restApiClient.login(username: username, password: password)
        switch result {
        case .success(_):
            authProtocol.loginSuccess()
        case .failure(let error):
            switch error {
            case .apiError(_, let code):
                if let errorCode = RestApiErrorCodes(rawValue: code) {
                    viewState = .failure(errorCode.localizedMessage)
                } else {
                    fatalError("Unhandled error code: \(code)")
                }
            case .parseError:
                fatalError("Unhandled parse error")
            }
        }
    }
}
