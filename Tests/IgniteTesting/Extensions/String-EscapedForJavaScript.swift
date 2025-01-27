//
//  String-EscapedForJavaScript.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-EscapedForJavaScript` extension.
@Suite("String-EscapedForJavaScript Tests")
@MainActor
struct StringEscapedForJavaScriptTests {
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
        "already-kebab-cased", // string is already kebab-cased
        "Hello World!",
        "camelCased",
        "kebab-cased"
    ])
    func does_not_change_simple_cases(string: String) async throws {
        #expect(string.escapedForJavascript() == string)
    }
    
    struct Instance {
        let input: String
        let expected: String
    }
    
    @Test("Replaces Single Quotes", arguments: [
        Instance(input: "'",
                 expected: "\\'"),
        Instance(input: "'whole string is single quoted'",
                 expected: "\\'whole string is single quoted\\'"),
        Instance(input: "word's shortened with apostrophe",
                 expected: "word\\'s shortened with apostrophe"),
        Instance(input: "single quotes 'appear' within 'string'",
                 expected: "single quotes \\'appear\\' within \\'string\\'")
    ])
    func replaces_single_quotes_with_escaped_quotes(instance: Instance) async throws {
        #expect(instance.input.escapedForJavascript() == instance.expected)
    }

}
