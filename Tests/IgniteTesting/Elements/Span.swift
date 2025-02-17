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
@MainActor class SpanTests: IgniteTestSuite {
    @Test("Single Element", arguments: ["This is a test", "Another test"])
    func singleElement(spanText: String) async throws {
        let element = Span(spanText)
        let output = element.render()

        #expect(output == "<span>\(spanText)</span>")
    }

    @Test("Builder", arguments: ["This is a test", "Another test"])
    func builder(spanText: String) async throws {
        let element = Span { spanText }
        let output = element.render()

        #expect(output == "<span>\(spanText)</span>")
    }
}
