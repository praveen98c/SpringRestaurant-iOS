//
//  RatingsView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation
import SwiftUI

public struct RatingsView: View {
    
    private let mockRating: Double = 4.8
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(mockRating) ? "star.fill" : (index < Int(ceil(mockRating)) ? "star.leadinghalf.filled" : "star"))
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.yellow)
            }
            
            Text(String(format: "%.1f", mockRating))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
