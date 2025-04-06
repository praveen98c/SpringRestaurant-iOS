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
        Group {
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
                enterInfo
                Text("Registration successful! Returning to login...")
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
                .modifier(LoginViewButtonModifier())
            
            SecureField("Enter your password", text: $viewModel.password)
                .modifier(LoginViewButtonModifier())
            
            
            TextField("Enter your name", text: $viewModel.name)
                .modifier(LoginViewButtonModifier())
            
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
