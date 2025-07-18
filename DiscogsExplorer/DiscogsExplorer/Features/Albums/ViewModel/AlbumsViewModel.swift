//  AlbumsViewModel.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation
//import SwiftUI

// ViewModel responsible for loading and filtering an artist's album releases.
@MainActor
final class AlbumsViewModel: ObservableObject {
  @Published var allReleases: [Release] = []       // full fetched list
  @Published var filteredReleases: [Release] = []  // visible after filters

  @Published var selectedYear: Int? = nil
  @Published var selectedLabel: String? = nil

  @Published var isLoading = false
  @Published var errorMessage: String?

  // MARK: - Computed Variables
  var isThereReleaseContent: Bool {
      !allReleases.isEmpty || !filteredReleases.isEmpty
  }

  // Extracted filter options for UI menus
  var availableYears: [Int] {
    Set(allReleases.compactMap { $0.year }).sorted(by: >)
  }

  var availableLabels: [String] {
    Set(allReleases.compactMap { $0.label }).sorted()
  }

  let artistID: Int
  private let apiService: DiscogsAPIServiceProtocol

  init(
    artistID: Int,
    apiService: DiscogsAPIServiceProtocol = DiscogsAPIService()
  ) {
    self.artistID = artistID
    self.apiService = apiService
  }

  // Clears the selected filter.
  func clearFilters() {
    self.selectedYear = nil
    self.selectedLabel = nil
    self.applyFilters()
  }

  func fetchReleases() async {
    isLoading = true
    errorMessage = nil
    allReleases = []

    do {
      let items = try await apiService.fetchArtistReleases(artistID: artistID)
      self.allReleases = items.releases
      self.applyFilters()
    } catch {
      self.errorMessage = error.localizedDescription
    }
    isLoading = false
  }

  // Appliying filters to 'allReleases'
  func applyFilters() {
    filteredReleases = allReleases.filter { release in
      let matchesYear = selectedYear == nil || release.year == selectedYear
      let matchesLabel = selectedLabel == nil || release.label == selectedLabel
      return matchesYear && matchesLabel
    }
  }
}
