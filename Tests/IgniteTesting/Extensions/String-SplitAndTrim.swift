//
//  String-SplitAndTrim.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-SplitAndTrim` extension.
@Suite("String-SplitAndTrim Tests")
@MainActor
struct StringSplitAndTrimTests {

    /// Some types of string will have an output that's the same as their input.
    /// Test examples of each of those cases
    @Test("Cases Where A One Element Array is the Result", arguments: [
        "a", // single character
        "1", // single digit
        "one", // single word
        "!", // single punctuation
        "Hello World!" // multi word
    ])
    func simple_cases_become_a_one_element_array(string: String) async throws {
        #expect(string.splitAndTrim() == [string])
    }

    @Test("Empty String Results in Empty Array")
    func empty_string_becomes_empty_array() async throws {
        #expect("".splitAndTrim() == [])
    }

    struct Instance {
        let input: String
        let expected: [String]
    }

    @Test("Comma-Separated with no spaces after commas", arguments: [
        Instance(input: "planes,trains,automobiles", expected: [
            "planes",
            "trains",
            "automobiles"
        ]),
        Instance(input: "1,2,3", expected: [
            "1",
            "2",
            "3"
        ])
    ])
    func comma_separated_without_spaces(instance: Instance) async throws {
        #expect(instance.input.splitAndTrim() == instance.expected)
    }

    @Test("Comma-Separated with spaces after commas", arguments: [
        Instance(input: "planes, trains, automobiles", expected: [
            "planes",
            "trains",
            "automobiles"
        ]),
        Instance(input: "1, 2, 3", expected: [
            "1",
            "2",
            "3"
        ]),
        Instance(input: "Bond, James Bond", expected: [
            "Bond",
            "James Bond"
        ])

    ])
    func comma_separated_followed_by_spaces(instance: Instance) async throws {
        #expect(instance.input.splitAndTrim() == instance.expected)
    }

    @Test("Comma-Separated with spaces before commas", arguments: [
        Instance(input: "planes , trains , automobiles", expected: [
            "planes",
            "trains",
            "automobiles"
        ]),
        Instance(input: " 1, 2 , 3", expected: [
            "1",
            "2",
            "3"
        ]),
        Instance(input: "Bond , James Bond", expected: [
            "Bond",
            "James Bond"
        ])

    ])
    func comma_separated_prepended_by_spaces(instance: Instance) async throws {
        #expect(instance.input.splitAndTrim() == instance.expected)
    }

    @Test("Empty Space Is Dropped Between Commas", arguments: [
        Instance(input: ",,,", expected: []),
        Instance(input: ",2,", expected: ["2"]),
        Instance(input: "Bond,, James Bond", expected: [
            "Bond",
            "James Bond"
        ])
    ])
    func drops_all_empty_strings_from_output(instance: Instance) async throws {
        #expect(instance.input.splitAndTrim() == instance.expected)
    }

    @Test("White Space Is Dropped From the Beginning and Ending of Strings between Commas", arguments: [
        Instance(input: "Bond\n,,\t James Bond\t", expected: [
            "Bond",
            "James Bond"
        ])
    ])
    func drops_whitespace_strings_before_and_after_strings_from_output(instance: Instance) async throws {
        #expect(instance.input.splitAndTrim() == instance.expected)
    }

    @Test("White Space Is Not Dropped Between Commas", arguments: [
        // you might expect that this input would result in an empty array,
        // but in fact it results in an array of two empty Strings
        Instance(input: ", ,\t,", expected: ["", ""]),

        // You might expect that this input would result in just ["2"],
        // but in fact it results in an array with two empty Strings
        // on either side of "2"
        Instance(input: "\t,2,\n", expected: [
            "", "2", ""
        ])
    ])
    func does_not_drop_whitespace_strings_from_output(instance: Instance) async throws {
        #expect(instance.input.splitAndTrim() == instance.expected)
    }
}
