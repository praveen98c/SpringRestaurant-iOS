//
//  LoginView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-04.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    let appContext: AppContext
    
    init(appContext: AppContext, authProtocol: AuthManagingProtocol) {
        self.appContext = appContext
        _viewModel = .init(wrappedValue: LoginViewModel(restApiClient: appContext.restApiClient, authProtocol: authProtocol))
    }
    
    var body: some View {
        VStack {
            loginCredentials
            switch viewModel.viewState {
            case .none:
                EmptyView()
            case .failure(let errorMessage):
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 5)
            case .networkRequestInProgress:
                ProgressView()
                    .padding(.bottom, 5)
            }
        }
    }
}

private extension LoginView {
    
    var loginCredentials: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.top, 50)
            
            TextField("Enter your username", text: $viewModel.username)
                .modifier(LoginTextFieldModifier())
            
            SecureField("Enter your password", text: $viewModel.password)
                .modifier(LoginTextFieldModifier())
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                Text("Login")
                    .modifier(LoginViewButtonModifier(isDisabled: viewModel.viewState.isNetworkRequestInProgress))
            }
            .disabled(viewModel.viewState.isNetworkRequestInProgress)
            .padding(.horizontal, 30)
        }
        .padding()
    }
}


