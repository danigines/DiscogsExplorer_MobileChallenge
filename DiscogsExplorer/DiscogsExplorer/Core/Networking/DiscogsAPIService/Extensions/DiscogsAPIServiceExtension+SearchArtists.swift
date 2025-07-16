//  DiscogsAPIServiceExtension+SearchArtists.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

extension DiscogsAPIService: DiscogsAPIServiceProtocol {
  /// Searches for artists by name using Discogs `/database/search` endpoint.
  ///
  /// - Parameters:
  ///   - query: The artist name to search for.
  /// - Returns: A decoded `SearchResponse` containing artist results and pagination info.
  /// - Throws: `APIError` if request fails, response is invalid, or decoding fails.
  func searchArtists(query: String) async throws -> SearchResponse {
    // Build the full URL with query parameters
    var components = URLComponents(
      url: Environment.baseURL.appendingPathComponent("database/search"),
      resolvingAgainstBaseURL: false)

    // Add required query parameters for search
    components?.queryItems = [
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "type", value: "artist") // limit to artist results
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

    // Attempt to decode the JSON data into our expected model
    do {
      return try JSONDecoder().decode(SearchResponse.self, from: data)
    } catch {
      // If decoding fails, return a decoding-specific error
      throw APIError.decodingError
    }
  }
}
