//  ViewModelFactoryProtocol.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import Foundation

// This tells the compiler: “This protocol method is expected to be run on the main actor.”
@MainActor 
protocol ViewModelFactoryProtocol {
  static func makeSearchViewModel() -> any SearchViewModelProtocol
}
