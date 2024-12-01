//
// PrivacySensitive.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Specifies what content should be encoded for privacy protection
public enum PrivacyEncoding: String {
    /// Only encode the URL (default)
    case urlOnly

    /// Encode both the URL and display text
    case urlAndDisplay
}

public extension Link {
    /// Marks this link as containing sensitive content that should be protected from scraping.
    /// Use this to protect email addresses, phone numbers, or other sensitive URLs from being
    /// scraped by bots while still remaining clickable for real users.
    ///
    /// - Parameter encoding: Controls what content gets encoded for privacy protection
    /// - Returns: A copy of the current link with protection enabled
    func privacySensitive(_ encoding: PrivacyEncoding = .urlOnly) -> Self {
        self.customAttribute(name: "privacy-sensitive", value: encoding.rawValue)
    }
}
