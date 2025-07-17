//  SearchView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel = SearchViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        // 🔍 Search Bar at the top
        TextField("Search for an artist", text: $viewModel.query)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)
          .onSubmit {
            Task { await viewModel.searchArtists() }
          }

        // Initial loading state
        if viewModel.isLoading && viewModel.results.isEmpty {
          Spacer()
          ProgressView("Searching...")
            .padding()
          Spacer()
        }
        // Empty state
        else if viewModel.results.isEmpty {
          Spacer()
          VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
              .font(.system(size: 40))
              .foregroundStyle(.secondary)
            Text("Start typing to search for artists")
              .font(.body)
              .foregroundStyle(.secondary)
          }
          Spacer()
        }
        // Results list
        else {
          List {
            ForEach(viewModel.results) { artist in
              NavigationLink {
                // Destination view: the detail view for this artist
                ArtistDetailView(artistID: artist.id)
              } label: {
                // What appears in the list row
                ArtistRowView(artist: artist)
              }
              // Show spinner at end of list when paginating
              if artist.id == viewModel.results.last?.id,
                 viewModel.isLoading {
                HStack {
                  Spacer()
                  ProgressView()
                    .padding(.vertical)
                  Spacer()
                }
              }
            }
          }
          .listStyle(.plain)
        }
      }
      .navigationTitle("Search")
      .alert("Error", isPresented: Binding<Bool>(
        get: { viewModel.errorMessage != nil },
        set: { _ in viewModel.errorMessage = nil }
      ), actions: {
        Button("OK", role: .cancel) { }
      }, message: {
        Text(viewModel.errorMessage ?? "Unknown error")
      })
    }
  }
}

// Preview
#Preview {
  SearchView()
}
