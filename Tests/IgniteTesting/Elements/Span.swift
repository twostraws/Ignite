//
// Span.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Span` element.
@Suite("Span Tests")
@MainActor struct SpanTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Single Element Test", arguments: ["This is a test", "Another test"])
    func test_singleElement(spanText: String) async throws {
        let element = Span(spanText)
        let output = element.render(context: publishingContext)

        #expect(output == "<span>\(spanText)</span>")
    }
    @Test("Builder Test", arguments: ["This is a test", "Another test"])
    func test_builder(spanText: String) async throws {
        let element = Span { spanText }
        let output = element.render(context: publishingContext)

        #expect(output == "<span>\(spanText)</span>")
    }
}
