//  ReleaseRowView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Represents a single album row in the albums list, navigable to album detail.
struct ReleaseRowView: View {
  let release: Release

  var body: some View {
    NavigationLink {
      // Use release ID for master endpoint
      AlbumDetailView(masterID: release.id)
    } label: {
      HStack(spacing: 12) {
        // Album thumbnail
        CachedImage(url: URL(string: release.thumb ?? "")) {
          Color.gray.opacity(0.2)
        }
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 8))

        // Album title and year
        VStack(alignment: .leading, spacing: 4) {
          Text(release.title)
            .font(.body)

          if let year = release.year {
            Text("Released: \(year)")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }

        Spacer()
      }
      .padding(.vertical, 4)
    }
  }
}
