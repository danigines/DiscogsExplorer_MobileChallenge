//  SearchViewTests.swift
//  DiscogsExplorerTests
//  Created by Daniel Garcia on 18/07/25.

@testable import DiscogsExplorer
import SwiftUI
import ViewInspector
import XCTest

@MainActor
final class SearchViewTests: XCTestCase {
  // System Under Test
  var sut: SearchView!
  var vm: MockSearchViewModel!

  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    setUpSUT()
  }

  override func tearDown() {
    sut = nil
    vm = nil
    super.tearDown()
  }

  // Helper to reset SUT for each test
  func setUpSUT(
    results: [ArtistSearchResult] = [],
    isLoading: Bool = false,
    errorMessage: String? = nil,
    query: String = "",
    isShowingError: Bool = false
  ) {
    vm = MockSearchViewModel()
    vm.results = results
    vm.isLoading = isLoading
    vm.errorMessage = errorMessage
    vm.query = query
    vm.isShowingError = isShowingError
    sut = SearchView(viewModel: self.vm)
  }

  func test_emptyResults_showsSearchPrompt() throws {
    // Given
    let view = sut
    // When
    let prompt = try view.inspect().find(text: "Start typing to search for artists")
    // Then
    XCTAssertEqual(try prompt.string(), "Start typing to search for artists")
  }

  func test_loading_showsProgressView() throws {
    // Given
    vm.isLoading = true
    vm.results = []
    let view = sut
    // When
    let inspected = try view.inspect()
    let progress = try inspected.find(ViewType.ProgressView.self)
    // Then
    XCTAssertNotNil(progress)
  }
}
