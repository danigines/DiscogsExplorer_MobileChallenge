//  SearchView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel = SearchViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        // Search bar at the top
        TextField("Search for an artist", text: $viewModel.query)
          .textFieldStyle(.roundedBorder)
          .padding()
          .onSubmit {
            Task { await viewModel.searchArtists() }
          }

        // Loading indicator
        if viewModel.isLoading && viewModel.results.isEmpty {
          ProgressView("Searching...")
            .padding()
        }

        // Empty state
        if viewModel.results.isEmpty && !viewModel.isLoading {
          Spacer()
          Text("Start typing to search for artists")
            .foregroundStyle(.secondary)
          Spacer()
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
