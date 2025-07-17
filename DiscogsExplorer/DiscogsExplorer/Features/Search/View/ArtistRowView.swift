//  ArtistRowView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct ArtistRowView: View {
  let artist: ArtistSearchResult

  var body: some View {
    HStack(spacing: 12) {
      // Thumbnail or placeholder
      AsyncImage(url: URL(string: artist.thumb ?? "")) { image in
        image.resizable()
      } placeholder: {
        Image(systemName: "person.crop.circle.fill")
          .resizable()
          .foregroundStyle(.secondary)
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
