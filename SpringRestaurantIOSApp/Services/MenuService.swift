//
//  MenuService.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-22.
//

import Foundation

protocol MenuServiceProtocol {
    func getMenusByRestaurantId(id: Int64) async -> Result<[MenuModel], RestAPIError>
}

class MenuService: MenuServiceProtocol {
    
    private let restApiClient: RestApiProtocol
    
    init(restApiClient: RestApiProtocol) {
        self.restApiClient = restApiClient
    }
    
    func getMenusByRestaurantId(id: Int64) async -> Result<[MenuModel], RestAPIError> {
        let result = await restApiClient.getMenusByRestaurantId(id: id)
        switch result {
        case .success(let menus):
            return .success(menus.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
}
