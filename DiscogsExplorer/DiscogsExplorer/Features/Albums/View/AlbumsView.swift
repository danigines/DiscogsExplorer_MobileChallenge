//  AlbumsView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct AlbumsView: View {
  @StateObject private var viewModel: AlbumsViewModel

  init(artistID: Int) {
    _viewModel = StateObject(
      wrappedValue: AlbumsViewModel(
        artistID: artistID
      )
    )
  }

  var body: some View {
    VStack {
      // 🔍 Filter Controls
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          filterPicker(
            title: "Year",
            selection: $viewModel.selectedYear,
            options: viewModel.availableYears
          )
          filterPicker(
            title: "Label",
            selection: $viewModel.selectedLabel,
            options: viewModel.availableLabels
          )
          filterPicker(
            title: "Format",
            selection: $viewModel.selectedGenre,
            options: viewModel.availableGenres
          )
          Button("Clear") {
            viewModel.selectedYear = nil
            viewModel.selectedLabel = nil
            viewModel.selectedGenre = nil
            viewModel.applyFilters()
          }
        }
        .padding(.horizontal)
      }

      // 📦 Releases List
      if viewModel.isLoading && viewModel.filteredReleases.isEmpty {
        Spacer()
        ProgressView("Loading albums...")
        Spacer()
      } else if viewModel.filteredReleases.isEmpty {
        Spacer()
        Text("No albums found for the selected filters.")
          .foregroundStyle(.secondary)
        Spacer()
      }
    }
    .navigationTitle("Albums")
    .task {
      await viewModel.fetchAlbums()
    }
  }

  // Generic Picker Builder
  private func filterPicker<T: Hashable & CustomStringConvertible>(
    title: String,
    selection: Binding<T?>,
    options: [T]
  ) -> some View {
    Menu {
      ForEach(options, id: \.self) { option in
        Button(option.description) {
          selection.wrappedValue = option
          viewModel.applyFilters()
        }
      }
    } label: {
      HStack {
        Text(selection.wrappedValue?.description ?? title)
        Image(systemName: "chevron.down")
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(Color.gray.opacity(0.2))
      .clipShape(Capsule())
    }
  }
}
