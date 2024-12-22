//
// PlainText.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for plain text.
@Suite("Plain Text Tests")
@MainActor struct PlainTextTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Single Element")
    func test_singleElement() async throws {
        let element = "This is a test"
        let output = element.render(context: publishingContext)

        #expect(output == "This is a test")
    }
}
