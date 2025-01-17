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
@MainActor struct StringTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Single Element", arguments: ["This is a test", ""])
    func test_singleElement(element: String) async throws {
        let element = element
        let output = element.render(context: publishingContext)

        #expect(output == element)
    }
}
