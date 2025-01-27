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
        "hello_happy_world" // words connected by underscores
    ])
    func does_not_change_simple_cases(string: String) async throws {
        #expect(string.kebabCased() == string)
    }
}
