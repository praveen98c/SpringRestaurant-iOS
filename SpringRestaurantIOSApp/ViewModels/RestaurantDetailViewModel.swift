//
//  RestaurantDetailViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-23.
//

import Foundation

class RestaurantDetailViewModel: ObservableObject {
    
    @Published var menus: [MenuModel] = []
    @Published var selectedMenu: MenuModel?
    let menuService: MenuServiceProtocol
    
    init(menuService: MenuServiceProtocol) {
        self.menuService = menuService
    }
    
    func loadMenus(restaurantId: Int64) {
        Task {
            let result = await menuService.getMenusByRestaurantId(id: restaurantId)
            switch result {
            case .success(let menus):
                await updateMenus(menus)
            case .failure(let error):
                break
                // handle error
            }
        }
    }
    
    @MainActor
    func updateMenus(_ menus: [MenuModel]) {
        self.menus = menus
    }
}
