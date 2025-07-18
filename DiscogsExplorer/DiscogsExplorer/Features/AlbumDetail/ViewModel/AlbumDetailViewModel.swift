//  AlbumDetailViewModel.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// ViewModel for fetching and exposing album metadata and tracklist.
@MainActor
final class AlbumDetailViewModel: ObservableObject {
  @Published var album: AlbumDetail?
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let apiService: DiscogsAPIServiceProtocol
  private let masterID: Int

  init(
    masterID: Int,
    apiService: DiscogsAPIServiceProtocol = DiscogsAPIService()
  ) {
    self.masterID = masterID
    self.apiService = apiService
  }

  // Fetches full album info from the Discogs API.
  func fetchAlbumDetail() async {
    isLoading = true
    errorMessage = nil
    album = nil

    do {
      album = try await apiService.fetchAlbumDetail(masterID: masterID)
    } catch {
      errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
    }

    isLoading = false
  }
}
