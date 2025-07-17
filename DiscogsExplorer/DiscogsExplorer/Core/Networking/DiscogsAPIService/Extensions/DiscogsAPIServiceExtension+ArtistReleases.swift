//  DiscogsAPIServiceExtension+ArtistReleases.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation
extension DiscogsAPIService {
  /// Searches for artists by name using Discogs `/database/search` endpoint.
  ///
  /// - Parameters:
  ///   - artistID: The unique ID for the artist.
  /// - Returns: A decoded `ReleaseResponse` containing artist results info.
  /// - Throws: `APIError` if request fails, response is invalid, or decoding fails.
  func fetchArtistReleases(artistID: Int) async throws -> ReleaseResponse {
    // Build the full URL with query parameters
    var components = URLComponents(
      url: Environment.baseURL.appendingPathComponent("artists/\(artistID)/releases"),
      resolvingAgainstBaseURL: false
    )

    // Add required query parameters for search
    components?.queryItems = [
      URLQueryItem(name: "sort", value: "year"),
      URLQueryItem(name: "sort_order", value: "desc")
    ]

    // Validate that URL is constructed correctly
    guard let url = components?.url else { throw APIError.invalidURL }

    // Prepare the request and attach the Discogs token via Authorization header
    var request = URLRequest(url: url)
    request.setValue(Environment.authHeader["Authorization"], forHTTPHeaderField: "Authorization")

    // Perform the network request asynchronously
    let (data, response) = try await session.data(for: request)

    // Ensure the response is an HTTP response
    guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }

    // Check if the status code is in the 200's success range
    guard 200..<300 ~= httpResponse.statusCode else { throw APIError.serverError(statusCode: httpResponse.statusCode) }

    // Attempt to decode the JSON data into our expected model -> ReleaseResponse
    do {
      return try JSONDecoder().decode(ReleaseResponse.self, from: data)
    } catch {
      // If decoding fails, return a decoding-specific error
      throw APIError.decodingError
    }
  }

}
