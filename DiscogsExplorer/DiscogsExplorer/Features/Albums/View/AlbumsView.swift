//  AlbumsView.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 16/07/25.

import SwiftUI

struct AlbumsView: View {
  let artistID: Int
  private let artistName: String
  @StateObject private var viewModel: AlbumsViewModel
  @Environment(\.dismiss) private var dismiss

  init(artistID: Int, artistName: String) {
    self.artistID = artistID
    self.artistName = artistName
    _viewModel = StateObject(
      wrappedValue: AlbumsViewModel(
        artistID: artistID
      )
    )
  }

  var body: some View {
    NavigationStack {
      VStack {
        // Show loading spinner while fetching data
        if viewModel.isLoading && viewModel.filteredReleases.isEmpty {
          Spacer()
          ProgressView("Loading albums...")
            .padding()
            .foregroundStyle(AppTheme.primaryText)
          Spacer()
        }
        else if let error = viewModel.errorMessage {
          VStack {
            Text("Error loading albums")
              .font(.headline)
              .foregroundStyle(AppTheme.primaryText)
            Text(error)
              .foregroundStyle(AppTheme.secondaryText)
          }
          .padding()
        }
        else if let error = viewModel.errorMessage {
          VStack {
            Text("Error loading albums")
              .font(.headline)
              .foregroundStyle(AppTheme.primaryText)
            Text(error)
              .foregroundStyle(AppTheme.secondaryText)
          }
          .padding()
        }
        else if viewModel.isThereReleaseContent {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
              filterPicker(
                title: "Year",
                selection: $viewModel.selectedYear,
                options: viewModel.availableYears
              )
              filterPicker(
                title: "Record Label",
                selection: $viewModel.selectedLabel,
                options: viewModel.availableLabels
              )
              Button("Clear") {
                viewModel.clearFilters()
              }
              .padding(.horizontal, 10)
              .padding(.vertical, 6)
              .background(.clear)
              .clipShape(Capsule())
              .overlay(
                Capsule()
                  .stroke(AppTheme.accent, lineWidth: 1)
              )
            }
            .padding(.horizontal)
          }
          setReleasesList(
            from: !viewModel.filteredReleases.isEmpty
            ? viewModel.filteredReleases : viewModel.allReleases
          )
        }
        else {
          Spacer()
          Text("No albums found :(.")
            .foregroundStyle(.secondary)
          Spacer()
        }
      }
      .navigationTitle("\(artistName) Albums")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Label("", systemImage: "chevron.left")
              .labelStyle(.iconOnly)
              .foregroundColor(AppTheme.primaryText)
          }
        }
      }
      .navigationBarBackButtonHidden(true)
      .background(Color.appBackground)
      .task {
        await viewModel.fetchReleases()
      }
    }  
  }
  
  private func setReleasesList(from releases: [Release]) -> some View {
    return List {
      ForEach(releases) { release in
        NavigationLink {
          // Destination view: the detail view for unfiltered album
          AlbumDetailView(
            masterID: release.id,
            albumName: release.title
          )
        } label: {
          // What appears in the list row
          ReleaseRowView(release: release)
        }
      }
    }
    .listStyle(.plain)
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
      .background(.clear) // background color of the selector,
      .clipShape(Capsule())
      .overlay(
        Capsule()
          .stroke(AppTheme.accent, lineWidth: 1)
      )
    }
  }
}
