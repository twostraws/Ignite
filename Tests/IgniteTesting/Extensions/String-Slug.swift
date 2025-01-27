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
        " ", // whitespace
        "  ",
        "\t",
        "\n",
        "\n\n",
        "😄", // single emoji
        "🤞👍😄" // multiple emoji
    ])
    func returns_nil_for_strings_with_no_latin_characters(string: String) async throws {
        #expect(string.convertedToSlug() == nil)
    }

}
