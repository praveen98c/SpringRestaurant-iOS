//
//  LoginScreen.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation
import SwiftUI

enum LoginViewType {
    case login
    case register
}

struct LoginScreen: View {
    
    let appContext: AppContext
    let authProtocol: AuthManagingProtocol
    @State var viewType: LoginViewType = .login
    
    init(appContext: AppContext, authProtocol: AuthManagingProtocol) {
        self.appContext = appContext
        self.authProtocol = authProtocol
    }
    
    var body: some View {
        VStack {
            switch viewType {
            case .login:
                LoginView(appContext: appContext, authProtocol: authProtocol)
            case .register:
                RegisterView(appContext: appContext, authProtocol: authProtocol)
            }
         
            Button(viewType == .login ? "Register ?" : "Login ?") {
                viewType = viewType == .login ? .register : .login
            }
        }
    }
}
