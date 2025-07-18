//  AlbumDetailView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Displays the full detail of an album including tracklist, image, and metadata.
struct AlbumDetailView: View {
  private let albumName: String
  @StateObject private var viewModel: AlbumDetailViewModel
  @Environment(\.dismiss) private var dismiss

  // Initializes with a master ID from the selected album.
  init(
    masterID: Int,
    albumName: String
  ) {
    self.albumName = albumName
    _viewModel = StateObject(
      wrappedValue: AlbumDetailViewModel(
        masterID: masterID
      )
    )
  }

  var body: some View {
    content
      .task {
        await viewModel.fetchAlbumDetail()
      }
      .background(AppTheme.background)
      .ignoresSafeArea(edges: .bottom)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss() // go back
          } label: {
            Label("", systemImage: "chevron.left")
              .labelStyle(.iconOnly)
              .foregroundColor(AppTheme.accent)
            }
          }
        }
      .navigationBarBackButtonHidden(true) // Hides system button
  }

  @ViewBuilder
  private var content: some View {
    // Show loading spinner while fetching data
    if viewModel.isLoading {
      ProgressView("Loading...")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else if let error = viewModel.errorMessage {
      VStack {
        Text("Error loading album details")
          .font(.headline)
          .foregroundStyle(AppTheme.primaryText)
        Text(error)
          .foregroundStyle(AppTheme.secondaryText)
      }
      .padding()
    } else if let album = viewModel.album {
      ScrollView {
        VStack(alignment: .leading, spacing: 10) {
          // Album Cover
          if let imageURL = album.images?.first?.uri {
            CachedImage(url: URL(string: imageURL))
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: 160, maxHeight: 160)
              .clipShape(Circle())
              .frame(maxWidth: .infinity, alignment: .center)
          }
          // Metadata
          VStack(alignment: .leading, spacing: 4) {
            if let year = album.year {
              Text("Year: \(String(format: "%d", year))")
                .foregroundColor(AppTheme.primaryText)
            }
            if let genres = album.genres, !genres.isEmpty {
              Text("Genres: \(genres.joined(separator: ", "))")
                .foregroundColor(AppTheme.primaryText)
            }
            if let labels = album.labels {
              let labelNames = labels.map { $0.name }
              Text("Labels: \(labelNames.joined(separator: ", "))")
                .foregroundColor(AppTheme.primaryText)
            }
          }
          .font(.title3) // .subheadline
          .foregroundStyle(AppTheme.secondaryText)
          // Tracklist
          if let tracks = album.tracklist, !tracks.isEmpty {
            Divider().padding(.vertical, 8)
            Text("Tracklist")
              .font(.headline)
              .foregroundColor(AppTheme.primaryText)
            ForEach(tracks) { track in
              HStack {
                Text(track.position)
                  .frame(width: 40, alignment: .leading)
                Text(track.title)
                  .lineLimit(1)
                Spacer()
                if let duration = track.duration {
                  Text(duration)
                    .foregroundStyle(AppTheme.secondaryText)
                    .font(.caption)
                }
              }
              .padding(.vertical, 2)
            }
          }
        }
        .padding()
      }
      .navigationTitle(albumName)
      .navigationBarTitleDisplayMode(.inline)
    } else {
      Text("Unexpected state.")
        .foregroundStyle(AppTheme.primaryText)
    }
  }
}
