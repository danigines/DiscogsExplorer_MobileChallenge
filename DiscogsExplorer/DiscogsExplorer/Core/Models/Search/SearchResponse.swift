//  SearchResponse.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import Foundation

struct SearchResponse: Codable {
  let results: [ArtistSearchResult]
}
