//
//  KeyChainValues.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

protocol KeyChainValuesProtocol {
    var authToken: String? { get set }
}

struct KeyChainValues: KeyChainValuesProtocol {
    
    @KeychainValue(key: .authToken, def: nil)
    var authToken: String?
}
