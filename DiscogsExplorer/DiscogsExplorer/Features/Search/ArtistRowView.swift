//  ArtistRowView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct ArtistRowView: View {
  let artist: ArtistSearchResult

  var body: some View {
    HStack {
      // ImageView
      AsyncImage(url: URL(string: artist.thumb ?? "")) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      } placeholder: {
        Color.gray.opacity(0.2)
      }
      .frame(width: 50, height: 50)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      // Label/Text
      Text(artist.title)
        .font(.body)
        .lineLimit(1)
      // Space
      Spacer()
    }
    .padding(.vertical, 4)
  }
}
