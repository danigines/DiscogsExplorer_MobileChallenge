//  DiscogsAPIServiceExtension+AlbumDetail.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

extension DiscogsAPIService {
  /// Fetches detailed information about a given artist by ID.
  ///
  /// - Parameter masterID: The ID to detailed information about an album.
  /// - Returns: An `AlbumDetail` object with full profile and band info.
  /// - Throws: `APIError` if request fails or decoding fails.
  func fetchAlbumDetail(masterID: Int) async throws -> AlbumDetail {
    // Construct the API endpoint
    let url = APIEnvironment.baseURL.appendingPathComponent("masters/\(masterID)")

    // Prepare the request and attach the Discogs token via Authorization header
    var request = URLRequest(url: url)
    request.setValue(APIEnvironment.authHeader["Authorization"], forHTTPHeaderField: "Authorization")

    // Perform the network request asynchronously
    let (data, response) = try await session.data(for: request)

    // Validate that URL is constructed correctly
    guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
    // Check if the status code is in the 200's success range
    guard 200..<300 ~= httpResponse.statusCode else { throw APIError.serverError(statusCode: httpResponse.statusCode) }
    // Attempt to decode the JSON data into our expected model -> AlbumDetail
    do {
      return try JSONDecoder().decode(AlbumDetail.self, from: data)
    } catch {
      // If decoding fails, return a decoding-specific error
      throw APIError.decodingError
    }
  }

}
