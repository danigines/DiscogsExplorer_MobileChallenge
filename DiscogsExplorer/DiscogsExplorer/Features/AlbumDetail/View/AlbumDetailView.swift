//  AlbumDetailView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Displays the full detail of an album including tracklist, image, and metadata.
struct AlbumDetailView: View {
  @StateObject private var viewModel: AlbumDetailViewModel

  // Initializes with a master ID from the selected album.
  init(masterID: Int) {
    _viewModel = StateObject(
      wrappedValue: AlbumDetailViewModel(
        masterID: masterID
      )
    )
  }

  var body: some View {
    Group {
      if viewModel.isLoading {
        ProgressView("Loading album…")
          .padding()
      } else if let album = viewModel.album {
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {

            // Album Cover
            if let imageURL = album.images?.first?.uri {
              AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable()
                default: Color.gray.opacity(0.2)
                }
              }
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity)
              .cornerRadius(12)
            }

            // Album Title
            Text(album.title)
              .font(.title.bold())

            // Metadata
            VStack(alignment: .leading, spacing: 4) {
              if let year = album.year {
                Text("Year: \(year)")
              }

              if let genres = album.genres, !genres.isEmpty {
                Text("Genres: \(genres.joined(separator: ", "))")
              }

              if let labels = album.labels {
                let labelNames = labels.map { $0.name }
                Text("Labels: \(labelNames.joined(separator: ", "))")
              }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            // Tracklist
            if let tracks = album.tracklist, !tracks.isEmpty {
              Divider().padding(.vertical, 8)
              Text("Tracklist")
                .font(.headline)
              ForEach(tracks) { track in
                HStack {
                  Text(track.position)
                    .frame(width: 40, alignment: .leading)
                  Text(track.title)
                    .lineLimit(1)
                  Spacer()
                  if let duration = track.duration {
                    Text(duration)
                      .foregroundStyle(.secondary)
                      .font(.caption)
                  }
                }
                .padding(.vertical, 2)
              }
            }
          }
          .padding()
        }
      } else if let error = viewModel.errorMessage {
        Text(error)
          .foregroundStyle(.red)
          .padding()
      }
    }
    .navigationTitle("Album Detail")
    .task {
      await viewModel.fetchAlbumDetail()
    }
  }
}
