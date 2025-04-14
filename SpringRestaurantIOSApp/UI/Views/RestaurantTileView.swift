//
//  RestaurantTileView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-20.
//

import Foundation
import SwiftUI

struct RestaurantTile: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var homeViewModel: RestaurantViewModel
    
    private let restaurant: RestaurantModel
    
    var isLandscape: Bool {
        horizontalSizeClass == .regular
    }
    
    init(restaurant: RestaurantModel, homeViewModel: RestaurantViewModel) {
        self.restaurant = restaurant
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        HStack {
            if isLandscape {
                Spacer(minLength: 16)
            }

            VStack(alignment: .leading, spacing: 8) {
                ImageView(imageUrl: restaurant.imageUrl) { url in
                    return homeViewModel.loadedImages[url]
                }
                .frame(height: 120)
                .clipped()
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .modifier(TitleModifier())
                    
                    RatingsView()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .cornerRadius(12)
            if isLandscape {
                Spacer(minLength: 16)
            }
        }
        .padding(.horizontal)
        .onAppear {
            homeViewModel.downloadImage(urlString: restaurant.imageUrl)
        }
        .onDisappear {
            homeViewModel.cancelDownloadImage(urlString: restaurant.imageUrl)
        }
    }
}
