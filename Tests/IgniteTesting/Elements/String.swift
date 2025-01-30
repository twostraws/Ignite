//
// String.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for Strings (aka Plain Text)
@Suite("String Tests")
@MainActor
class StringTests: IgniteTestSuite {
    @Test("Single Element", arguments: ["This is a test", ""])
    func singleElement(element: String) async throws {
        let element = element
        let output = element.render()

        #expect(output == element)
    }
}
