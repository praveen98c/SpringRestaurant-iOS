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
    @Environment(\.dismiss) private var dismiss
    
    let appContext: AppContext
    
    init(appContext: AppContext, authProtocol: AuthManagingProtocol) {
        self.appContext = appContext
        _viewModel = .init(wrappedValue: RegisterViewModel(restApiClient: appContext.restApiClient, authProtocol: authProtocol))
    }
    
    var body: some View {
        VStack {
            enterInfo
            switch viewModel.viewState {
            case .none:
                EmptyView()
            case .failure(let error):
                Text(error)
                    .foregroundColor(.red)
                    .padding(.bottom, 5)
            case .networkRequestInProgress:
                ProgressView()
                    .padding(.bottom, 5)
            case .success:
                Text("Registration successful! Returning to login...")
                    .padding(.bottom, 5)
            }
        }
        .onAppear {
            viewModel.dismissAction = {
                dismiss()
            }
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
                .modifier(LoginTextFieldModifier())
            
            SecureField("Enter your password", text: $viewModel.password)
                .modifier(LoginTextFieldModifier())
            
            
            TextField("Enter your name", text: $viewModel.name)
                .modifier(LoginTextFieldModifier())
            
            Button(action: {
                Task {
                    await viewModel.register()
                }
            }) {
                Text("Register")
                    .modifier(LoginViewButtonModifier(isDisabled: viewModel.viewState.isNetworkRequestInProgress))
            }
            .disabled(viewModel.viewState.isNetworkRequestInProgress)
            .padding(.horizontal, 30)
        }
        .padding()
    }
}
