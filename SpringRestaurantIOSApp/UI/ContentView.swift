//
//  ContentView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    let appContext: AppContext
    
    init(appContext: AppContext, authViewModel: AuthViewModel) {
        self.appContext = appContext
        self.authViewModel = authViewModel
    }
    
    var body: some View {
        NavigationStack {
            switch authViewModel.authState {
            case .authenticated:
                HomeScreen(authManaging: authViewModel)
            case .notAuthenticated:
                LoginScreen(appContext: appContext, authProtocol: authViewModel)
            case .checking:
                ProgressView()
            }
        }
        .onAppear() {
            authViewModel.verifyToken()
        }
    }
}

#Preview {
    let appContext = AppContext()
    ContentView(appContext: appContext, authViewModel: AuthViewModel(keyChainValues: appContext.keychainValues, jwtHelper: appContext.jwtHelper))
}
