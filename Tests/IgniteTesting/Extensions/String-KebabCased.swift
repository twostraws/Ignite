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
        "hello_happy_world",
        "!", // single punctuation
        "up!", // punctuation at end of word
        "c.",
        "#&?$#+", // group of punctuation together
        "already-kebab-cased" // string is already kebab-cased
    ])
    func does_not_change_simple_cases(string: String) async throws {
        #expect(string.kebabCased() == string)
    }

    @Test("Converts Whitespace to Dashes", arguments: [
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

    /// Simple type meant to represent input paired with expected output
    struct Instance {
        let input: String
        let expected: String
    }

    @Test("Converts camelCase to words-separated-by-dashes", arguments: [
        Instance(input: "camelCase", expected: "camel-case"),
        Instance(input: "threeWordExample", expected: "three-word-example"),
        Instance(input: "aLongerExampleWithSixWords", expected: "a-longer-example-with-six-words")
    ])
    func converts_camelCase_to_words_separated_by_dashes(instance: Instance) async throws {
        #expect(instance.input.kebabCased() == instance.expected)
    }

    @Test("Converts words-separated-by-dashes to all lowercase", arguments: [
        Instance(input: "Hello-World", expected: "hello-world"),
        Instance(input: "Hello-world", expected: "hello-world"),
        Instance(input: "hello-World", expected: "hello-world"),
        Instance(input: "HELLO-WORLD", expected: "hello-world")
    ])
    func converts_to_lowercase_leaving_dashes (instance: Instance) async throws {
        #expect(instance.input.kebabCased() == instance.expected)
    }

    @Test(
        "Complex Examples",
        arguments: [
            Instance(input: "keepsPunctuation!",
                     expected: "keeps-punctuation!"),
            Instance(input: "Lowercases Capitals and Replaces Spaces",
                     expected: "lowercases-capitals-and-replaces-spaces"),
            Instance(input: "ignores_underscores-and-dashes and replaces spaces",
                     expected: "ignores_underscores-and-dashes-and-replaces-spaces"),
            Instance(input: "retains commas, and follows them with dashes",
                     expected: "retains-commas,-and-follows-them-with-dashes")
        ]
    )
    func complex_examples(instance: Instance) async throws {
        #expect(instance.input.kebabCased() == instance.expected)
    }

}
