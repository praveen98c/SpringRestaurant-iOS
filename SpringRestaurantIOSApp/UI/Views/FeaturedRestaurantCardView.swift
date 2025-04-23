//
//  FeaturedRestaurantView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-20.
//

import Foundation
import SwiftUI

struct FeaturedRestaurantCardView: View {
    
    let restaurant: RestaurantModel
    @ObservedObject var homeViewModel: RestaurantViewModel
    @ObservedObject var imageViewModel: ImageViewModel
    private let mockRating: Double = 4.8
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageView(imageUrl: restaurant.imageUrl) { url in
                return imageViewModel.loadedImages[url]
            }
            .frame(width: 160, height: 100)
            .clipped()
            .cornerRadius(10)
            
            Text(restaurant.name)
                .modifier(TitleModifier())
            
            RatingsView()
        }
        .padding()
        .cornerRadius(12)
        .onAppear {
            imageViewModel.downloadImage(urlString: restaurant.imageUrl)
        }
        .onDisappear {
            imageViewModel.cancelDownloadImage(urlString: restaurant.imageUrl)
        }
    }
}
