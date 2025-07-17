//  ArtistDetailView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Displays the detailed information for an artist, including profile, image, and band members.
struct ArtistDetailView: View {
  @StateObject private var viewModel: ArtistDetailViewModel

  /// Accepts the artist ID passed from the search view.
  init(artistID: Int) {
    _viewModel = StateObject(
      wrappedValue: ArtistDetailViewModel(
        artistID: artistID
      )
    )
  }

  var body: some View {
    Group {
      // Show loading spinner while fetching data
      if viewModel.isLoading {
        ProgressView("Loading artist info…")
          .padding()
      }

      // Display artist content once loaded
      else if let artist = viewModel.artist {
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {

            // Display main image if available
            if let image = artist.images?.first(where: { $0.type == "primary" }) {
              AsyncImage(url: URL(string: image.uri)) { phase in
                switch phase {
                case .success(let image): image.resizable()
                default: Color.gray.opacity(0.2)
                }
              }
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity)
              .cornerRadius(12)
            }

            // Artist name
            Text(artist.name)
              .font(.largeTitle.bold())

            // Optional profile/description
            if let profile = artist.profile {
              Text(profile)
                .font(.body)
                .foregroundStyle(.secondary)
            }

            // Show band members (if it's a band)
            if let members = artist.members, !members.isEmpty {
              VStack(alignment: .leading, spacing: 4) {
                Text("Band Members")
                  .font(.headline)
                ForEach(members) { member in
                  HStack {
                    Text(member.name)
                    Spacer()
                    if member.active {
                      Text("Active")
                        .font(.caption)
                        .foregroundStyle(.green)
                    }
                  }
                }
              }
              .padding(.top, 12)
            }

            // TODO: Navigation to albums
          }
          .padding()
        }
      }

      // Display error message if one exists
      else if let error = viewModel.errorMessage {
        Text(error)
          .foregroundStyle(.red)
          .padding()
      }
    }
    .navigationTitle("Artist Info")
    .task {
      await viewModel.fetchArtistDetail()
    }
  }
}
