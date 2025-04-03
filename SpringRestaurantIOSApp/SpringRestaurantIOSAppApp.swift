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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
