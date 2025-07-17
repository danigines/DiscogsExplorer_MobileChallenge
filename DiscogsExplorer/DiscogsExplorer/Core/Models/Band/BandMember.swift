//  BandMember.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

// Represents a member of a band (artist with sub-members).
struct BandMember: Codable, Identifiable {
  let id: Int
  let name: String
  let active: Bool
}
