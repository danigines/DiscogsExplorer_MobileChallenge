//  ImageExtension.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Helper to extract UIImage from SwiftUI Image
extension Image {
  // Attempts to extract a UIImage from the SwiftUI Image.
  func extractUIImage() -> UIImage? {
    let mirror = Mirror(reflecting: self)
    return mirror.descendant("provider", "base", "image") as? UIImage
  }
}
