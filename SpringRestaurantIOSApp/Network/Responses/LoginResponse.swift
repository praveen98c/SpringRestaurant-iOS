//
//  LoginResponse.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-03.
//

import Foundation

struct LoginData: Codable {
    let token: String
}

struct LoginResponse : Codable {
    let data: LoginData
    let message: String
    
    var token: String? {
        return data.token
    }
}
