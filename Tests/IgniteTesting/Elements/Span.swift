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
class SpanTests: IgniteTestSuite {
    @Test("Single Element", .publishingContext(), arguments: ["This is a test", "Another test"])
    func singleElement(spanText: String) async throws {
        let element = Span(spanText)
        let output = element.markupString()

        #expect(output == "<span>\(spanText)</span>")
    }

    @Test("Builder", .publishingContext(), arguments: ["This is a test", "Another test"])
    func builder(spanText: String) async throws {
        let element = Span { spanText }
        let output = element.markupString()

        #expect(output == "<span>\(spanText)</span>")
    }
}
