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
    
    struct Instance {
        let input: String
        let expected: String
    }

    @Test("Transliterates Non-latin Scripts", arguments: [
        // I've tried to use non-controversial words here
        // "peace" in two of the scripts
        // and "oolong tea" in the other two.
        // these were also just very easy-to-find words online
        // as I don't speak any of these languages.
        // No stereotyping or cultural judgment is intended
        Instance(input: "烏龍茶", expected: "wu-long-cha"),
        Instance(input: "ウーロン茶", expected: "uron-cha"),
        Instance(input: "שָׁלוֹם", expected: "salwom"),
        Instance(input: "שָׁלוֹםسلام", expected: "salwomslam"),
        Instance(input: "שָׁלוֹםسلام" + "שָׁלוֹם" + "烏龍茶" + "ウーロン茶", expected: "salwomslamsalwom-wu-long-chauron-cha"),

    ])
    func transliterates_characters_in_non_latin_scripts(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

}
