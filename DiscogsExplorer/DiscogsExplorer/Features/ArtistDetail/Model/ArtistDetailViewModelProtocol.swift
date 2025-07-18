//  ArtistDetailViewModelProtocol.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import Foundation

/// Protocol defining the ArtistDetailViewModel.
@MainActor
protocol ArtistDetailViewModelProtocol: ObservableObject, AnyObject {
  var artist: ArtistDetail? { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get set }

  func fetchArtistDetail() async
}
