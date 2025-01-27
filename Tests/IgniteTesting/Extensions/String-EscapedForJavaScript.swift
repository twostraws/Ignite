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
        "kebab-cased",
        "`" // left single quotation mark is not escaped
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

    @Test("Replaces Quotation Marks", arguments: [
        Instance(input: "\"",
                 expected: "&quot;"),
        Instance(input: "\"whole string has quotation marks\"",
                 expected: "&quot;whole string has quotation marks&quot;"),
        Instance(input: "quotation marks \"appear\" within \"string\"",
                 expected: "quotation marks &quot;appear&quot; within &quot;string&quot;")
    ])
    func replaces_quotation_marks_with_html_escaped_quot_sequence(instance: Instance) async throws {
        #expect(instance.input.escapedForJavascript() == instance.expected)
    }

    @Test("Combined Examples", arguments: [
        Instance(input: "\"a quote 'string' with 'single quotes' within it\"",
                 expected: "&quot;a quote \\'string\\' with \\'single quotes\\' within it&quot;"),
        Instance(input: "programmer's example of a string with \"quotation\" marks and an apostrophe",
                 expected: "programmer\\'s example of a string with &quot;quotation&quot; marks and an apostrophe"),
        Instance(input: "programmer`s example with \"quotation\" marks and a left single apostrophe",
                 expected: "programmer`s example with &quot;quotation&quot; marks and a left single apostrophe")
    ])
    func combined_examples(instance: Instance) async throws {
        #expect(instance.input.escapedForJavascript() == instance.expected)
    }

}
