//
//  String-Slug.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-Slug` extension.
@Suite("String-Slug Tests")
@MainActor
struct StringSlugTests {
    
    /// Strings that don't contain latin characters output nil
    @Test("Nil Cases", arguments: [
        "", // empty string
        "!", // single punctuation
        "#&?$#+", // group of punctuation together
        "ウィキペディア", // katakana
        "燒賣", // chinese writing
        "燒賣\n燒賣\tウィキペディア", // non-latin scripts with whitespace
        "😄", // single emoji
        "🤞👍😄" // multiple emoji
    ])
    func returns_nil_for_strings_with_no_latin_characters(string: String) async throws {
        #expect(string.convertedToSlug() == nil)
    }

}
