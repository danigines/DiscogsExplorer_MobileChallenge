//  MockSearchViewModel.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

@testable import DiscogsExplorer
import Foundation

final class MockSearchViewModel: SearchViewModelProtocol {
  @Published var results: [ArtistSearchResult] = []
  @Published var query: String = ""
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?
  @Published var isShowingError: Bool = false

  var searchCalled = false

  func searchArtists() async {
    searchCalled = true
  }
}
