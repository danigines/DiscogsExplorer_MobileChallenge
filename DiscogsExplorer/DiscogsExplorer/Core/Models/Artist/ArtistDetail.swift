//  ArtistDetail.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

/// Represents detailed information about an artist from Discogs.
struct ArtistDetail: Codable {
  let id: Int
  let name: String
  let profile: String?
  let images: [DiscogsImage]?
  let members: [BandMember]?
  let releasesURL: String?

  enum CodingKeys: String, CodingKey {
    case id, name, profile, images, members
    case releasesURL = "releases_url" // maps snake_case from API
  }
}
