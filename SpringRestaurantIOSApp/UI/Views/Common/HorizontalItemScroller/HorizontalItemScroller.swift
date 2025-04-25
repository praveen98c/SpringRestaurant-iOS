//
//  HorizontalItemScroller.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-25.
//

import Foundation
import SwiftUI

struct HorizontalItemScroller<T: ItemProtocol>: View {
    
    @Binding private var items: [T]
    private let title: String
    @StateObject private var imageViewModel: ImageViewModel
    var onTap: (T) -> Void
    
    init(title: String, items: Binding<[T]>, imageService: ImageServiceProtocol, onTap: @escaping (T) -> Void) {
        _items = items
        self.title = title
        _imageViewModel = StateObject(wrappedValue: ImageViewModel(imageService: imageService))
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .modifier(SectionTitleModifier())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.id) { item in
                        Button(action: {
                            onTap(item)
                        }) {
                            HorizontalItemScrollerCardView(item: item, imageViewModel: imageViewModel)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}
