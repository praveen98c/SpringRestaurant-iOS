//
//  ImageService.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-18.
//

import Foundation
import SwiftUI

protocol ImageServiceProtocol {
    func fetchImage(from url: URL, maxSize: CGSize) async throws -> UIImage?
}

actor ImageService: ImageServiceProtocol {
    
    private var cache = NSCache<NSURL, UIImage>()
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchImage(from url: URL, maxSize: CGSize) async throws -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        let result = await networkManager.request(url: url)
        switch result {
        case .success(let data):
            let resizedImage = await resizeIfNeeded(imageData: data, maxSize: maxSize)
            guard let image = resizedImage else {
                throw URLError(.badServerResponse)
            }
            cache.setObject(image, forKey: url as NSURL)
            return image
        case .failure(_):
            return nil
        }
    }
    
    private func resizeIfNeeded(imageData: Data, maxSize: CGSize) async -> UIImage? {
        let scale: CGFloat = await UIScreen.main.scale
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else { return nil }
        
        let maxDimensionInPixels = max(maxSize.width, maxSize.height) * scale
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
