//  DiscogsImage.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Represents an image attached to an artist (e.g. primary photo).
struct DiscogsImage: Codable {
  let uri: String
  let type: String
}
