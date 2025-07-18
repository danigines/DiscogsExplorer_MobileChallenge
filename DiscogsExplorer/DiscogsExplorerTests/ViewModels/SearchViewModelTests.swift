//  SearchViewModelTests.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

@testable import DiscogsExplorer
import XCTest

@MainActor
final class SearchViewModelTests: XCTestCase {
  // MARK: - System Under Test
  var sut: SearchViewModel!
  var mockService: MockDiscogsAPIService!

  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockService = MockDiscogsAPIService()
    setUpSUT() // default setup
  }

  override func tearDown() {
    sut = nil
    mockService = nil
    super.tearDown()
  }

  // MARK: - Helpers
  func setUpSUT(
    query: String = "Beatles",
    errorToThrow: Error? = nil
  ) {
    mockService.errorToThrow = errorToThrow
    sut = SearchViewModel(apiService: mockService)
    sut.query = query
  }

  func test_searchArtists_success_setsResultsAndStopsLoading() async {
    // Given
    let expectedArtist = ArtistSearchResult(
      id: 29735,
      title: "Coldplay",
      type: "artist",
      thumb: "https://i.discogs.com/V90awgfHX4AGcdXYb6M4w8Sl",
      resourceURL: "https://api.discogs.com/artists/29735"
    )
    mockService.mockArtistSearchResults = [expectedArtist]
    
    // When
    await sut.searchArtists()
    
    // Then
    let result = sut.results.first
    XCTAssertFalse(sut.isLoading)
    XCTAssertNil(sut.errorMessage)
    XCTAssertEqual(sut.results.count, 1)
    XCTAssertEqual(result?.id, expectedArtist.id)
    XCTAssertEqual(result?.title, expectedArtist.title)
    XCTAssertEqual(result?.type, expectedArtist.type)
    XCTAssertEqual(result?.thumb, expectedArtist.thumb)
    XCTAssertEqual(result?.resourceURL, expectedArtist.resourceURL)
  }

  func test_searchArtists_failure_setsErrorAndClearsResults() async {
    // Given
    let error = APIError.invalidURL
    mockService.resetAllResults()
    mockService.errorToThrow = error

    // When
    await sut.searchArtists()

    // Then
    XCTAssertFalse(sut.isLoading)
    XCTAssertNotNil(sut.errorMessage)
    XCTAssertEqual(sut.errorMessage, error.errorDescription)
    XCTAssertTrue(sut.results.isEmpty)
  }

  func test_searchArtists_withEmptyQuery_doesNotTriggerSearch() async {
    // Given
    mockService.resetAllResults()
    setUpSUT(query: "  ") // whitespace only

    // When
    await sut.searchArtists()

    // Then
    XCTAssertTrue(sut.results.isEmpty)
    XCTAssertFalse(sut.isLoading)
    XCTAssertNil(sut.errorMessage)
  }
}
