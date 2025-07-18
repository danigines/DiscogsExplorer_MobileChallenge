//  SearchViewModelProtocol.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import Foundation

/// Protocol defining the SearchViewModel.
@MainActor
protocol SearchViewModelProtocol: ObservableObject, AnyObject {
  var query: String { get set }
  var results: [ArtistSearchResult] { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get set }

  func searchArtists() async
}
