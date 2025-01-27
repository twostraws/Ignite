//
//  String-KebabCased.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-KebabCased` extension.
@Suite("String-KebabCased Tests")
@MainActor
struct StringKebabCasedTests {
    
    
    /// Some types of string will have an output that's the same as their input.
    /// Test examples of each of those cases
    @Test("Noop Cases", arguments: [
        "", // empty string
        "a", // single character
        "1", // single digit
        "one", // single word
        "hello_world", // words connected by underscores
        "hello_happy_world", // words connected by underscores
        "!", // single punctuation
        "up!", // punctuation at end of word
        "c.",
        "#&?$#+", // group of punctuation together
        "already-kebab-cased" // string is already kebab-cased
    ])
    func does_not_change_simple_cases(string: String) async throws {
        #expect(string.kebabCased() == string)
    }
    
    @Test("Converts to Dashes", arguments: [
        " ",
        "  ",
        "\t",
        "\n",
        "\n\n"
    ])
    func converts_whitespaces_to_dashes(string: String) async throws {
        #expect(string.kebabCased() == "-")
    }
    
    @Test("Converts Single Words To Lowercase", arguments: [
        "A",
        "CARS",
        "Cars",
        "Hollywood"
    ])
    func converts_capitals_to_lowercase(string: String) async throws {
        #expect(string.kebabCased() == string.lowercased())
    }

    @Test("Concatenates With Dashes", arguments: [
        "a b",
        "one two",
        "buckle my shoe"
    ])
    func concatenates_words_with_dashes(string: String) async throws {
        #expect(string.kebabCased() == string.replacingOccurrences(of: " ", with: "-"))
    }

}
