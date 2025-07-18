//  SearchViewModelContainerTests.swift
//  DiscogsExplorerTests
//  Created by Daniel Garcia on 18/07/25.

import XCTest
@testable import DiscogsExplorer

@MainActor
final class SearchViewModelContainerTests: XCTestCase {
  // MARK: - System Under Test
  var sut: SearchViewModelContainer!
  var mockVM: MockSearchViewModel!

  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    setUpSUT()
  }

  override func tearDown() {
    sut = nil
    mockVM = nil
    super.tearDown()
  }

  // MARK: - Helper
  func setUpSUT(
    query: String = "Beatles",
    isLoading: Bool = false,
    results: [ArtistSearchResult] = [],
    errorMessage: String? = nil,
    isShowingError: Bool = false
  ) {
    mockVM = MockSearchViewModel()
    mockVM.query = query
    mockVM.isLoading = isLoading
    mockVM.results = results
    mockVM.errorMessage = errorMessage
    mockVM.isShowingError = isShowingError

    sut = SearchViewModelContainer(mockVM)
  }

  // MARK: - Tests
  func test_initialModelStateIsCorrect() {
    // Given
    let text = "Beatles"
    // Then
    XCTAssertEqual(sut.model.query, text)
    XCTAssertFalse(sut.model.isLoading)
    XCTAssertTrue(sut.model.results.isEmpty)
    XCTAssertNil(sut.model.errorMessage)
  }

  func test_updatingModelReflectsInContainer() {
    // Given
    mockVM.query = "Queen"
    mockVM.isLoading = true
    mockVM.results = [
      ArtistSearchResult(
        id: 29510,
        title: "Freddy",
        type: "artist",
        thumb: "https://i.discogs.com/V90awgfHX4AGcdXYb6M4w8Sl",
        resourceURL: "https://api.discogs.com/artists/29510"
      )
    ]
    // When
    mockVM.errorMessage = "Oops"
    mockVM.isShowingError = true
    // Then
    XCTAssertEqual(sut.model.query, "Queen")
    XCTAssertTrue(sut.model.isLoading)
    XCTAssertEqual(sut.model.results.count, 1)
    XCTAssertEqual(sut.model.errorMessage, "Oops")
  }

  func test_containerHoldsSameModelInstance() {
    // Then
    XCTAssertTrue(sut.model === mockVM)
  }
}
