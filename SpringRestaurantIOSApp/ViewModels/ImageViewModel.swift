//
//  ImageViewModel.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-23.
//

import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {
    
    @Published var loadedImages: [URL: UIImage?] = [:]
    private let maxSize = CGSize(width: 100, height: 100)
    private var ongoingImageFetchingTasks: [URL: Task<(), Never>] = [:]
    private let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if let _ = ongoingImageFetchingTasks[url] {
            return
        }
        
        let task = Task { [weak self] in
            guard let self = self else { return }
            defer { ongoingImageFetchingTasks[url] = nil }
            do {
                guard let image = try await imageService.fetchImage(from: url, maxSize: maxSize) else {
                    return
                }
                
                await updateImage(url: url, image: image)
            } catch {
                print("Image download error for \(urlString): \(error)")
            }
        }
        
        ongoingImageFetchingTasks[url] = task
    }
    
    func cancelDownloadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadedImages[url] = nil
        if let existingTask = ongoingImageFetchingTasks[url] {
            existingTask.cancel()
        }
    }
    
    @MainActor
    private func updateImage(url: URL, image: UIImage) {
        loadedImages[url] = image
    }
}
