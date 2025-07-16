//  APIError.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

enum APIError: Error, LocalizedError, Equatable {
  case invalidURL
  case invalidResponse
  case decodingError
  case serverError(statusCode: Int)
  case noData
  case custom(message: String)

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL."
    case .invalidResponse:
      return "The server response was not valid."
    case .decodingError:
      return "Failed to decode the data."
    case .serverError(let code):
      return "Server returned error code \(code)."
    case .noData:
      return "No data was received."
    case .custom(let message):
      return message
    }
  }
}
