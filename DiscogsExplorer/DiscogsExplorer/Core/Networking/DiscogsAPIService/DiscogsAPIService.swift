//  DiscogsAPIService.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Concrete implementation of the API service using `URLSession` and `async/await`.
final class DiscogsAPIService: DiscogsAPIServiceProtocol {
  private(set) var session: URLSession

  // Default initializer uses `URLSession.shared` but can be overridden for testing.
  init(session: URLSession = .shared) {
    self.session = session
  }
}
