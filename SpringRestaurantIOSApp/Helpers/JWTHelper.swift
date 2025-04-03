//
//  JWTHelper.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

protocol JWTHelperProtocol {
    func decodeJWT(token: String) -> [String: Any]?
    func isTokenExpired(token: String) -> Bool
}

struct JWTHelper: JWTHelperProtocol {
    func decodeJWT(token: String) -> [String: Any]? {
        let segments = token.split(separator: ".")
        
        guard segments.count == 3,
              let payloadData = Data(base64Encoded: String(segments[1]), options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: payloadData, options: [])
            return json as? [String: Any]
        } catch {
            return nil
        }
    }
    
    func isTokenExpired(token: String) -> Bool {
        guard let payload = decodeJWT(token: token),
              let exp = payload["exp"] as? Double else {
            return true
        }
        
        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate < Date()
    }
}
