//  ReleaseRowView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct ReleaseRowView: View {
    let release: Release

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: release.thumb ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))

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
