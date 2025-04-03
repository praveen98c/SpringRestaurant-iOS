//
//  KeyChainHelper.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

struct KeychainHelper {
    
    fileprivate static let shared = KeychainHelper()
    
    private init() {}
    
    func saveData(_ data: Data, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving data to Keychain: \(status)")
        }
    }
    
    func readData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return data
        } else {
            print("Error reading data from Keychain: \(status)")
            return nil
        }
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting data from Keychain: \(status)")
        }
    }
}

@propertyWrapper
struct KeychainValue<T: Codable> {
    private let key: KeyChainKeys
    private let def: T
    private let keychainHelper = KeychainHelper.shared
    
    init(key: KeyChainKeys, def: T) {
        self.key = key
        self.def = def
    }
    
    var wrappedValue: T {
        get {
            guard let data = keychainHelper.readData(forKey: key.rawValue) else { return def }
            return (try? JSONDecoder().decode(T.self, from: data)) ?? def
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                keychainHelper.saveData(data, forKey: key.rawValue)
            }
        }
    }
}

enum KeyChainKeys: String {
    case authToken
}
