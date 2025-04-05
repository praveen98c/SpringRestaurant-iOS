//
//  RegisterView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-04.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel: RegisterViewModel
    
    let appContext: AppContext
    
    init(appContext: AppContext, authProtocol: AuthManagingProtocol) {
        self.appContext = appContext
        _viewModel = .init(wrappedValue: RegisterViewModel(restApiClient: appContext.restApiClient, authProtocol: authProtocol))
    }
    var body: some View {
        switch viewModel.viewState {
        case .enterInfo:
            enterInfo
        case .failure(let error):
            enterInfo
            Text(error)
                .foregroundColor(.red)
                .padding(.top, 10)
        case .loading:
            ProgressView()
        case .success:
            Text("Success")
        }
    }
}

private extension RegisterView {
    
    var enterInfo: some View {
        VStack {
            Text("Register")
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
            
            
            SecureField("Enter your name", text: $viewModel.name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .padding(.top, 20)
            
            Button(action: {
                Task {
                    await viewModel.register()
                }
            }) {
                Text("Register")
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
