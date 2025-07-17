//  ArtistSearchResult.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

struct ArtistSearchResult: Codable, Identifiable {
  let id: Int
  let title: String
  let type: String
  let thumb: String?
  let resourceURL: String

  enum CodingKeys: String, CodingKey {
    case id, title, type, thumb
    case resourceURL = "resource_url"
  }
}
