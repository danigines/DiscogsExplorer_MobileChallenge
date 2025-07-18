//  MockDiscogsAPIService.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 18/07/25.

import Foundation
@testable import DiscogsExplorer

final class MockDiscogsAPIService: DiscogsAPIServiceProtocol {
    var errorToThrow: Error?
    var mockAlbumDetailResult: AlbumDetail?
    var mockArtistDetailResult: ArtistDetail?
    var mockArtistSearchResults: [ArtistSearchResult]?
    var mockReleaseResponseResult: ReleaseResponse?

    func searchArtists(query: String) async throws -> SearchResponse {
        if let error = errorToThrow { throw error }
        guard let mockResults = mockArtistSearchResults else { throw APIError.noData }
        return SearchResponse(results: mockResults)
    }

    func fetchArtistDetail(id: Int) async throws -> ArtistDetail {
        if let error = errorToThrow { throw error }
        guard let mockResult = mockArtistDetailResult else { throw APIError.noData }
        return mockResult
    }

    func fetchArtistReleases(artistID: Int) async throws -> ReleaseResponse {
        if let error = errorToThrow { throw error }
        guard let mockResult = mockReleaseResponseResult else { throw APIError.noData }
        return mockResult
    }

    func fetchAlbumDetail(masterID: Int) async throws -> AlbumDetail {
        if let error = errorToThrow { throw error }
        guard let mockResult = mockAlbumDetailResult else { throw APIError.noData }
        return mockResult
    }

    func resetAllResults() {
        self.errorToThrow = nil
        self.mockAlbumDetailResult = nil
        self.mockArtistDetailResult = nil
        self.mockArtistSearchResults = nil
        self.mockReleaseResponseResult = nil
    }
}
