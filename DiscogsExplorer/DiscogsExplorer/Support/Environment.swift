//  Environment.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

struct APIEnvironment {
    // MARK: - API
    static let baseURL = URL(string: "https://api.discogs.com")!

    // Store this securely in a real app (e.g., Keychain or backend). For now, add it directly:
    static let apiToken: String = "MY_DISCOGS_TOKEN" // ← replace with the actual token

    // Discogs requires the Authorization header format below
    static var authHeader: [String: String] {
        ["Authorization": "Discogs token=\(apiToken)"]
    }
}

/*
   ⚠️ In a real-world project, never commit secrets like API tokens to version control.
   We ussually use environment variables, .xcconfig, or secret managers instead.
*/
