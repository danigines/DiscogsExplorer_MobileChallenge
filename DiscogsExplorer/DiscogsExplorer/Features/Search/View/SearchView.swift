//  SearchView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct SearchView: View {
  @StateObject private var container: SearchViewModelContainer

  init(viewModel: @autoclosure @escaping () -> any SearchViewModelProtocol) {
    _container = StateObject(wrappedValue: SearchViewModelContainer(viewModel()))
  }

  var body: some View {
    NavigationStack {
      VStack {
        // Search Bar at the top
        TextField(
          "",
          text: $container.model.query,
          prompt: Text("Search for an artist")
            .foregroundColor(AppTheme.placeholderText)
        )
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)
          .onSubmit {
            Task { await container.model.searchArtists() }
          }

        // Initial loading state
        if container.model.isLoading && container.model.results.isEmpty {
          Spacer()
          ProgressView("Searching...")
            .padding()
            .foregroundStyle(AppTheme.primaryText)
          Spacer()
        }
        // Empty state
        else if container.model.results.isEmpty {
          Spacer()
          VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
              .font(.system(size: 40))
              .foregroundStyle(.secondary)
            Text("Start typing to search for artists")
              .font(.body)
              .foregroundColor(AppTheme.primaryText)
          }
          Spacer()
        }
        // Results list
        else {
          List {
            ForEach(container.model.results) { artist in
              NavigationLink {
                // Destination view: the detail view for this artist
                ArtistDetailView(artistID: artist.id)
              } label: {
                // What appears in the list row
                ArtistRowView(artist: artist)
              }
            }
          }
          .listStyle(.plain)
        }
      }
      .background(AppTheme.background)
      .navigationTitle("Discogs Artist Explorer")
      .foregroundColor(AppTheme.primaryText)
      .alert("Error", isPresented: Binding<Bool>(
        get: { container.model.errorMessage != nil },
        set: { _ in container.model.errorMessage = nil }
      ), actions: {
        Button("OK", role: .cancel) { }
      }, message: {
        Text(container.model.errorMessage ?? "Unknown Error")
      })
    }
  }
}

// Preview
#Preview {
  SearchView(viewModel: SearchViewModel())
}
