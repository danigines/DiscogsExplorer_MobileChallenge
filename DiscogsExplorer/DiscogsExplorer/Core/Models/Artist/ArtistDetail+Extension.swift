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
      if let formattedArtistList = self.formattedArtistList(profile) {
        profile = formattedArtistList
      }
    }

    // Replace \r\n and \n with a newline for paragraph spacing
    profile = profile.replacingOccurrences(of: "\\r\\n|\\n", with: "\n", options: .regularExpression)

    // Trim excess whitespace
    return profile.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Extracts & process all [a=...] artist references from a profile.
  func formattedArtistList(_ profile: String) -> String? {
    let pattern = #"(,?\s*)?\[a=([^\]]+)\]"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: profile, range: NSRange(profile.startIndex..., in: profile))

    guard !matches.isEmpty else { return profile }

    // Extract only the names (group 2)
    let artistNames = matches.map {
      String(profile[Range($0.range(at: 2), in: profile)!])
    }

    if artistNames.count == 1 {
      // Replace the single tag with the name directly
      return profile.replacingOccurrences(of: "[a=\(artistNames[0])]", with: artistNames[0])
    }

    // Replace all [a=...] along with preceding commas and spaces
    var cleanedText = regex.stringByReplacingMatches(
      in: profile,
      options: [],
      range: NSRange(profile.startIndex..., in: profile),
      withTemplate: ""
    ).trimmingCharacters(in: .whitespacesAndNewlines)

    // Remove trailing commas, if any remain
    if cleanedText.hasSuffix(",") {
      cleanedText.removeLast()
    }

    // Add the list of artists
    let bulletList = artistNames.map { "• \($0)" }.joined(separator: "\n")
    return "\(cleanedText)\n\(bulletList)"
  }
}
