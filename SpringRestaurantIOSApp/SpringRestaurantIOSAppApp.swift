//
//  SpringRestaurantIOSAppApp.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import SwiftUI

@main
struct SpringRestaurantIOSAppApp: App {
    
    let persistenceController = PersistenceController.shared
    let appContext: AppContext
    @StateObject private var authViewModel: AuthViewModel
    
    init() {
        let appContext = AppContext()
        _authViewModel = StateObject(wrappedValue: AuthViewModel(keyChainValues: appContext.keychainValues, jwtHelper: appContext.jwtHelper))
        self.appContext = appContext
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(appContext: appContext, authViewModel: authViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
