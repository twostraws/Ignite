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
    
    /// Some types of string will have an output that's the same as their input.
    /// Test examples of each of those cases
    @Test("Noop Cases", arguments: [
        "a", // single character
        "1", // single digit
        "one", // single word
        "hello-world", // kebab-cased
        "hello-wonderful-world",
    ])
    func does_not_change_simple_cases(string: String) async throws {
        #expect(string.convertedToSlug() == string)
    }

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
    
    @Test("Converts Title-Cased Single Words To Lowercase", arguments: [
        "A",
        "Cars",
        "Hollywood"
    ])
    func converts_title_case_to_lowercase(string: String) async throws {
        #expect(string.convertedToSlug() == string.lowercased())
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

    @Test("Strips Leading and Trailing Punctuation", arguments: [
        // I've tried to use non-controversial words here
        // "peace" in two of the scripts
        // and "oolong tea" in the other two.
        // these were also just very easy-to-find words online
        // as I don't speak any of these languages.
        // No stereotyping or cultural judgment is intended
        Instance(input: "up!", expected: "up"),
        Instance(input: "c.", expected: "c"),
        Instance(input: ".lowercase", expected: "lowercase"),

    ])
    func strips_punctuation_from_ends_of_string(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }
    
    @Test("Replaces Underscaore with Dashes", arguments: [
        Instance(input: "hello_world", expected: "hello-world"),
        Instance(input: "hello_happy_world", expected: "hello-happy-world")
    ])
    func reaplces_underscores_with_dashes(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Concatenates Lowercase Words With Dashes", arguments: [
        "a b",
        "one two",
        "buckle my shoe"
    ])
    func concatenates_lowercase_words_with_dashes(string: String) async throws {
        #expect(string.convertedToSlug() == string.replacingOccurrences(of: " ", with: "-"))
    }

    @Test("Converts camelCase to dash-case", arguments: [
        Instance(input: "camelCase", expected: "camel-case"),
        Instance(input: "threeWordExample", expected: "three-word-example"),
        Instance(input: "aLongerExampleWithSixWords", expected: "a-longer-example-with-six-words")
    ])
    func converts_camelCase_to_dash_case(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }
}
