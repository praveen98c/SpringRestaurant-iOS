//
//  HorizontalScrollItemCardView.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-20.
//

import Foundation
import SwiftUI

struct ItemCardView<T: ItemProtocol>: View {
    
    let item : T
    @ObservedObject var imageViewModel: ImageViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageView(imageUrl: item.imageUrl) { url in
                return imageViewModel.loadedImages[url]
            }
            .frame(width: 160, height: 100)
            .clipped()
            .cornerRadius(10)
            
            Text(item.title)
                .modifier(TitleModifier())
            
            RatingsView(rating: item.rating)
        }
        .padding()
        .cornerRadius(12)
        .onAppear {
            imageViewModel.downloadImage(urlString: item.imageUrl)
        }
        .onDisappear {
            imageViewModel.cancelDownloadImage(urlString: item.imageUrl)
        }
    }
}
