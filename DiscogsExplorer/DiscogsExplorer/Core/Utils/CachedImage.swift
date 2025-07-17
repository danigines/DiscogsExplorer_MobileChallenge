//  CachedImage.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Reusable image view with custom caching support.
struct CachedImage: View {
  let url: URL?
  var placeholder: () -> AnyView
  @State private var loadedImage: UIImage?

  // Initializes with a placeholder view and optional URL.
  init(
    url: URL?,
    @ViewBuilder placeholder: @escaping () -> some View = {
      AppTheme.placeholderBackground // loading background
    }
  ) {
    self.url = url
    self.placeholder = { AnyView(placeholder()) }
  }

  var body: some View {
    if let url,
       let cached = ImageCacheManager.shared.get(forKey: url.absoluteString) {
      Image(uiImage: cached).resizable() // Use cached image if available
    } else if let url {
      // Load via AsyncImage if not cached
      AsyncImage(url: url) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .task {
              // Store image after load completes
              if loadedImage == nil {
                loadedImage = image.extractUIImage()
                if let uiImage = loadedImage {
                  ImageCacheManager.shared.set(uiImage, forKey: url.absoluteString)
                }
              }
            }
        case .failure, .empty:
          placeholder()
        @unknown default:
          placeholder()
        }
      }
    } else {
      // Invalid or nil URL fallback
      placeholder()
    }
  }
}
