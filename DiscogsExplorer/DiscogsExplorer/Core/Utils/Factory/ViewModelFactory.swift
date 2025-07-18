//  ViewModelFactory.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import Foundation

@MainActor
struct ViewModelFactory: ViewModelFactoryProtocol {
  static func makeSearchViewModel() -> any SearchViewModelProtocol {
    SearchViewModel(apiService: DiscogsAPIService())
  }
}
