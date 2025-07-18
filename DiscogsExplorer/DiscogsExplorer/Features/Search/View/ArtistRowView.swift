//  ArtistRowView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// A single row representing a search result for an artist.
struct ArtistRowView: View {
  let artist: ArtistSearchResult

  var body: some View {
    HStack(spacing: 12) {
      // Thumbnail or placeholder
      CachedImage(url: URL(string: artist.thumb ?? "")) {
        Image(systemName: "person.crop.circle.fill")
          .resizable()
          .foregroundStyle(AppTheme.secondaryText)
          .opacity(0.3)
      }
      .frame(width: 50, height: 50)
      .clipShape(RoundedRectangle(cornerRadius: 8))

      // Artist name
      Text(artist.title)
        .font(.body)
        .lineLimit(1)
      // Space
      Spacer()
    }
    .padding(.vertical, 6)
  }
}
