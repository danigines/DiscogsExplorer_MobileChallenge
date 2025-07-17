//  AlbumsViewModel.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// ViewModel responsible for loading and filtering an artist's album releases.
@MainActor
final class AlbumsViewModel: ObservableObject {
  // MARK: - Published State
  @Published var allReleases: [Release] = []       // full fetched list
  @Published var filteredReleases: [Release] = []  // visible after filters

  @Published var selectedYear: Int? = nil
  @Published var selectedLabel: String? = nil
  @Published var selectedGenre: String? = nil

  @Published var isLoading: Bool = false
  @Published var errorMessage: String? = nil
  
  // MARK: - Computed Variables
  // Extracted filter options for UI menus
  var availableYears: [Int] {
    Set(allReleases.compactMap { $0.year }).sorted(by: >)
  }

  var availableLabels: [String] {
    Set(allReleases.flatMap { $0.label ?? [] }).sorted()
  }

  var availableGenres: [String] {
    Set(allReleases.flatMap { $0.format ?? [] }).sorted()
  }

  // MARK: - Internal State
  private let apiService: DiscogsAPIServiceProtocol
  private let artistID: Int

  // MARK: - Init
  init(
    artistID: Int,
    apiService: DiscogsAPIServiceProtocol = DiscogsAPIService()
  ) {
    self.artistID = artistID
    self.apiService = apiService
  }

  // MARK: - Public API
  // Initial fetch or refresh (resets all state)
  func fetchAlbums() async {
    isLoading = true
    errorMessage = nil
    allReleases = []

    do {
      let response = try await apiService.fetchArtistReleases(artistID: artistID)
      allReleases = response.releases
      applyFilters()
    } catch {
      errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
    }

    isLoading = false
  }

  // Appliying filters to 'allReleases'
  func applyFilters() {
    filteredReleases = allReleases.filter { release in
      let matchesYear = selectedYear == nil || release.year == selectedYear
      let matchesLabel = selectedLabel == nil || release.label?.contains(where: { $0 == selectedLabel }) == true
      let matchesGenre = selectedGenre == nil || release.format?.contains(where: { $0 == selectedGenre }) == true
      return matchesYear && matchesLabel && matchesGenre
    }
  }
}
