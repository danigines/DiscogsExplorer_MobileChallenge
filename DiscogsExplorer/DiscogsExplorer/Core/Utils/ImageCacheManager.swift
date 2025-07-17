//  ImageCacheManager.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import UIKit

// A lightweight in-memory image cache backed by NSCache.
final class ImageCacheManager {
  // Singleton instance to share cache across the app.
  static let shared = ImageCacheManager()

  // NSCache stores images using their URL string as the key.
  private let cache = NSCache<NSString, UIImage>()

  private init() {}

  // Retrieves an image from the cache for the given key.
  func get(forKey key: String) -> UIImage? {
    cache.object(forKey: key as NSString)
  }

  // Saves an image to the cache for the given key.
  func set(_ image: UIImage, forKey key: String) {
    cache.setObject(image, forKey: key as NSString)
  }
}
