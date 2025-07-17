//  SearchViewModel.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
  // MARK: - Published UI State
  @Published var results: [ArtistSearchResult] = []
  @Published var query: String = ""
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  // MARK: - Dependencies
  private let apiService: DiscogsAPIServiceProtocol

  // MARK: - Init
  init(apiService: DiscogsAPIServiceProtocol = DiscogsAPIService()) {
    self.apiService = apiService
  }

  // MARK: - Public Methods
  /// Performs a new search, resetting results and page state.
  func searchArtists() async {
    // Prevent empty queries
    guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
      results = []
      return
    }

    isLoading = true
    errorMessage = nil

    do {
      let response = try await apiService.searchArtists(query: query)
      results = response.results
    } catch {
      results = []
      errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
    }

    isLoading = false
  }
}
