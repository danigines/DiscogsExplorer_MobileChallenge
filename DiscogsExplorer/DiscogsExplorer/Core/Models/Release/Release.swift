//  Release.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Represents a single album or release in the artist’s discography.
struct Release: Codable, Identifiable {
  let id: Int
  let title: String
  let year: Int?
  let format: [String]?
  let label: [String]?
  let type: String
  let thumb: String?
  let resourceURL: String

  enum CodingKeys: String, CodingKey {
    case id, title, year, format, label, type, thumb
    case resourceURL = "resource_url"
  }
}
