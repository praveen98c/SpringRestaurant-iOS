//
//  HomeViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation
import SwiftUI

class RestaurantScreenViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigateTo(_ item: any ItemProtocol) {
        navigationPath.append(item)
    }
}
