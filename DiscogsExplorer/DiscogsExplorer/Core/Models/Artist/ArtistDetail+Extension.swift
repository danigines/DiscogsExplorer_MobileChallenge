//  ArtistDetail+Extension.swift
//  DiscogsExplorer
//  Created by Daniel Garcia on 17/07/25.

import Foundation

extension ArtistDetail {
  var isABand: Bool {
    guard let members = self.members else { return false }
    return !members.isEmpty
  }
    
  /// Cleans Discogs-formatted profile strings by removing BBCode and line breaks.
  var cleanedProfileText: String? {
    guard var profile = self.profile else { return nil }

    // Remove BBCode tags like [b], [u], etc.
    let patterns = ["\\[/?[a-z]+\\]"]
    for pattern in patterns {
      profile = profile.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }

    // Validate if the artist is a band, and process/delete certain information
    if self.isABand {
      if let range = profile.range(of: "Line-up:", options: [.caseInsensitive]) {
        profile = String(profile[..<range.lowerBound])
      }
    } else {
      let tags = self.getArtistTags(profile)
      // Map each artist to a line that begins with a bullet
      return tags.map { "• \($0)" }.joined(separator: "\n")
    }

    // Replace \r\n and \n with a newline for paragraph spacing
    profile = profile.replacingOccurrences(of: "\\r\\n|\\n", with: "\n", options: .regularExpression)

    // Trim excess whitespace
    return profile.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Extracts all [a=...] artist references from a profile.
  private func getArtistTags(_ profile: String) -> [String] {
    // This matches [a=Artist Name] and captures just the "Artist Name" part.
    let pattern = "\\[a=([^\\]]+)\\]"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    //  Convert `self` into NSString to use NSRange-based matching.
    let nsString = profile as NSString
    // Find all matches of the pattern in the string - If none found, return [].
    let results = regex?.matches(in: profile, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
    return results.map { match in
      // Capture group 1 contains what's inside [a=...]
      nsString.substring(with: match.range(at: 1))
    }
  }
}

