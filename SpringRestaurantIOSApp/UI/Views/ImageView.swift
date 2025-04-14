//
//  ImageView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-21.
//

import Foundation
import SwiftUI

struct ImageView: View {
    
    let imageUrl: String
    
    let imageClosure: (URL) -> UIImage??
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
            if
                let url = URL(string: imageUrl),
                let uiImage = imageClosure(url) {
                if let image =  uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            } else {
                ProgressView()
            }
        }
    }
}
