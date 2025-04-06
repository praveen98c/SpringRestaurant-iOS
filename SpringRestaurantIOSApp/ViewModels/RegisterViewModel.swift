//
//  RegisterViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-04.
//

import Foundation
import SwiftUI

enum RegisterViewFeedbackState {
    case none
    case failure(String)
    case networkRequestInProgress
    case success
    
    var isNetworkRequestInProgress: Bool {
        if case .networkRequestInProgress = self {
            return true
        } else {
            return false
        }
    }
}

@MainActor
class RegisterViewModel: ObservableObject {
    
    var dismissAction: (() -> Void)?
    
    @Published var viewState: RegisterViewFeedbackState = .none
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
        
        viewState = .networkRequestInProgress
        let result = await restApiClient.register(username: username, password: password, name: name)
        switch result {
        case .success(_):
            viewState = .success
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.dismissAction?()
            }
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
