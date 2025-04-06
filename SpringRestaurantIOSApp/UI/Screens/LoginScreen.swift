//
//  LoginScreen.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation
import SwiftUI

struct LoginScreen: View {
    
    let appContext: AppContext
    let authProtocol: AuthManagingProtocol
    
    init(appContext: AppContext, authProtocol: AuthManagingProtocol) {
        self.appContext = appContext
        self.authProtocol = authProtocol
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                LoginView(appContext: appContext, authProtocol: authProtocol)
                NavigationLink(
                    destination: RegisterView(appContext: appContext, authProtocol: authProtocol)
                ) {
                    Text("Register")
                }
            }
        }
    }
}
