//  ArtistDetailViewModel.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

/// ViewModel responsible for fetching and exposing artist details to the view.
@MainActor
final class ArtistDetailViewModel: ObservableObject {
  // MARK: - Published Properties
  @Published var artist: ArtistDetail? // The loaded artist details to display.
  @Published var isLoading = false
  @Published var errorMessage: String?

  // MARK: - Dependencies & State
  private let apiService: DiscogsAPIServiceProtocol
  private let artistID: Int

  // MARK: - Initializer
  init(
    artistID: Int,
    apiService: DiscogsAPIServiceProtocol = DiscogsAPIService()
  ) {
    self.artistID = artistID
    self.apiService = apiService
  }

  // MARK: - Public API
  /// Fetches the full artist details from the API.
  func fetchArtistDetail() async {
    isLoading = true
    errorMessage = nil

    do {
      artist = try await apiService.fetchArtistDetail(id: artistID)
    } catch {
      errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
    }

    isLoading = false
  }
}
