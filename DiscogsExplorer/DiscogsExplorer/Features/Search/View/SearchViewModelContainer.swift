//  SearchViewModelContainer.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import SwiftUI

// Keep protocol abstraction by creating a small ObservableObject wrapper that owns your any SearchViewModelProtocol
@MainActor
final class SearchViewModelContainer: ObservableObject {
  @Published var model: any SearchViewModelProtocol
  @Published var isLoading: Bool = false
  @Published var results: [ArtistSearchResult] = []
  @Published var errorMessage: String?

  init(_ model: any SearchViewModelProtocol) {
    self.model = model
    // Observe model changes manually
    setupBindings()
  }

  private func setupBindings() {
    (model as? SearchViewModel)?.$isLoading.assign(to: &$isLoading)
    (model as? SearchViewModel)?.$results.assign(to: &$results)
    (model as? SearchViewModel)?.$errorMessage.assign(to: &$errorMessage)
  }
}
