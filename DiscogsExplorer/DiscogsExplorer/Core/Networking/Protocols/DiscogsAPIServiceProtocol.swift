//  DiscogsAPIServiceProtocol.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Protocol defining the public API surface for Discogs-related requests.
protocol DiscogsAPIServiceProtocol {
  /// Searches for artists using a query string.
  func searchArtists(query: String) async throws -> SearchResponse
  /// Searches for artists detail an ID.
  func fetchArtistDetail(id: Int) async throws -> ArtistDetail
  /// Searches for artist releases such as year, label, genre.
  func fetchArtistReleases(artistID: Int) async throws -> ReleaseResponse
  /// Fetches detailed information about an album (from the master endpoint).
  func fetchAlbumDetail(masterID: Int) async throws -> AlbumDetail
}
