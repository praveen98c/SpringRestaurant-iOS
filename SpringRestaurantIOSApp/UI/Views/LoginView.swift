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
        switch viewModel.viewState {
        case .enterCredentials:
            loginCredentials
        case .failure(let error):
            Text(error)
                .foregroundColor(.red)
                .padding(.top, 10)
        case .loading:
            ProgressView()
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
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 30)
            
            SecureField("Enter your password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .padding(.top, 20)
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 30)
        }
        .padding()
    }
}


