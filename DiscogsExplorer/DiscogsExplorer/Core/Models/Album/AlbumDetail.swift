//  AlbumDetail.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Represents the full album detail data.
struct AlbumDetail: Codable {
  let id: Int
  let title: String
  let year: Int?
  let genres: [String]?
  let labels: [AlbumLabel]?
  let tracklist: [AlbumTrack]?
  let images: [DiscogsImage]?
}
