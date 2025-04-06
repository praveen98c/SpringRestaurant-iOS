//
//  RestApiCodes.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-05.
//

import Foundation

enum RestApiErrorCodes: Int {
    
    case userAlreadyExists = 2001
    case userNotFound = 2002
    case authFailed = 2003
    
    var localizedMessage: String {
        switch self {
        case .userAlreadyExists:
            return NSLocalizedString("User already exists", comment: "User already exists error")
        case .userNotFound:
            return NSLocalizedString("User not found", comment: "User not found error")
        case .authFailed:
            return NSLocalizedString("Authentication failed", comment: "Authentication failure error")
        }
    }
}
