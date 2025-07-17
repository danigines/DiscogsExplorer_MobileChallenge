//  DiscogsAPIServiceExtension+ArtistDetail.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

extension DiscogsAPIService {
  /// Fetches detailed information about a given artist by ID.
  ///
  /// - Parameter id: The unique Discogs ID for the artist.
  /// - Returns: An `ArtistDetail` object with full profile and band info.
  /// - Throws: `APIError` if request fails or decoding fails.
  func fetchArtistDetail(id: Int) async throws -> ArtistDetail {
    // Construct the API endpoint: /artists/{id}
    let url = Environment.baseURL.appendingPathComponent("artists/\(id)")
    // Prepare the request and attach the Discogs token via Authorization header
    
    var request = URLRequest(url: url)
    request.setValue(Environment.authHeader["Authorization"], forHTTPHeaderField: "Authorization")

    let (data, response) = try await session.data(for: request)

    // Validate that URL is constructed correctly
    guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
    // Check if the status code is in the 200's success range
    guard 200..<300 ~= httpResponse.statusCode else { throw APIError.serverError(statusCode: httpResponse.statusCode) }

    // Attempt to decode the JSON data into our expected model -> ArtistDetail
    do {
      return try JSONDecoder().decode(ArtistDetail.self, from: data)
    } catch {
      // If decoding fails, return a decoding-specific error
      throw APIError.decodingError
    }
  }
}
