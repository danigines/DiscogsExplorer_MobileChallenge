//  DiscogsAPIServiceProtocol.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

/// Protocol defining the public API surface for Discogs-related requests.
protocol DiscogsAPIServiceProtocol {
  /// Searches for artists using a query string.
  func searchArtists(query: String) async throws -> SearchResponse
  /// Searches for artists detail an ID.
  func fetchArtistDetail(id: Int) async throws -> ArtistDetail
}
