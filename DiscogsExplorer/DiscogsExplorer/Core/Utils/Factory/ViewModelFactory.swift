//  ViewModelFactory.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import Foundation

@MainActor
struct ViewModelFactory: ViewModelFactoryProtocol {
  func makeSearchViewModel() -> any SearchViewModelProtocol {
    SearchViewModel(apiService: DiscogsAPIService())
  }
}
