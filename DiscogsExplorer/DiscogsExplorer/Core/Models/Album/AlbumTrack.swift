//  AlbumTrack.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Represents a single track in an album’s tracklist.
struct AlbumTrack: Codable, Identifiable {
  let position: String         // Position of the track on the album (e.g., A1, B2)
  let title: String
  let duration: String?        // Optional duration string (e.g., "3:45")
  var id: String { position }  // Makes the track identifiable for use in SwiftUI views.
}
