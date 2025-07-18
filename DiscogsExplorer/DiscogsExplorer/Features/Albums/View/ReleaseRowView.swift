//  ReleaseRowView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Represents a single album row in the albums list, navigable to album detail.
struct ReleaseRowView: View {
  let release: Release

  var body: some View {
    HStack(spacing: 12) {
      // Album thumbnail
      CachedImage(url: URL(string: release.thumb ?? "")) {
        AppTheme.placeholderBackground
      }
      .frame(width: 50, height: 50)
      .clipShape(RoundedRectangle(cornerRadius: 8))

      // Album title and year
      VStack(alignment: .leading, spacing: 4) {
        Text(release.title)
          .font(.title3)
          .foregroundStyle(AppTheme.primaryText)

        if let year = release.year {
          Text("Released: \(String(format: "%d", year))")
            .font(.body)
            .foregroundStyle(AppTheme.secondaryText)
        }

        if let label = release.label {
          Text("Record Label: \(label)")
            .font(.caption)
            .foregroundStyle(AppTheme.secondaryText)
        }
      }

      Spacer()
    }
    .padding(.vertical, 4)
  }
}
