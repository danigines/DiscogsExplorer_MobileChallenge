//  ArtistDetailView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

// Displays the detailed information about a selected artist, including profile, members, and a link to view their albums.
struct ArtistDetailView: View {
  let artistID: Int
  @Environment(\.dismiss) private var dismiss

  // Holds the view model and manages state for this screen.
  @StateObject private var viewModel: ArtistDetailViewModel

  /// Initializes the view and injects a view model.
  init(artistID: Int) {
    self.artistID = artistID
    _viewModel = StateObject(
      wrappedValue: ArtistDetailViewModel(
        artistID: artistID
      )
    )
  }

  var body: some View {
    content
      .task {
        await viewModel.fetchArtistDetail()
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
    if viewModel.isLoading {
      // Show loading spinner while fetching data
      ProgressView("Loading...")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else if let error = viewModel.errorMessage {
      VStack {
        Text("Error loading artist")
          .font(.headline)
          .foregroundStyle(AppTheme.primaryText)
        Text(error)
          .foregroundStyle(AppTheme.secondaryText)
      }
      .padding()
    } else if let artist = viewModel.artist {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // Display main image if available
          if let artistImage = artist.images?.first?.uri {
            CachedImage(url: URL(string: artistImage))
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: 160, maxHeight: 160)
              .clipShape(Circle())
              .frame(maxWidth: .infinity, alignment: .center)
          }

          // Profile / Description
          if let profile = artist.cleanedProfileText {
            Text(profile)
              .font(.body)
              .foregroundStyle(AppTheme.secondaryText)
          }

          // Show band members (if it's a band)
          if let members = artist.members,
             !members.isEmpty {
            Text("Band Members")
              .font(.title2.bold())
              .padding(.top)

            ForEach(members, id: \.id) { member in
              Text(member.name)
                .foregroundStyle(AppTheme.primaryText)
            }
          }

          // Navigation to Albums View
          NavigationLink {
            AlbumsView(artistID: artistID, artistName: artist.name)
          } label: {
            Label("View Albums", systemImage: "opticaldisc")
              .padding()
              .frame(maxWidth: .infinity)
              .background(AppTheme.accent)
              .foregroundStyle(AppTheme.whiteText)
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
          .padding(.top)
        }
        .padding()
      }
      .navigationTitle(artist.name)
      .navigationBarTitleDisplayMode(.inline)
    } else {
      Text("Unexpected state.")
        .foregroundStyle(AppTheme.primaryText)
    }
  }
}
