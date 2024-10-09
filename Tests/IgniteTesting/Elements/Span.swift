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
struct SpanTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Single Element Test")
    func test_singleElement() async throws {
        let element = Span("This is a test")
        let output = element.render(context: publishingContext)

        #expect(output == "<span>This is a test</span>")
    }
    @Test("Builder Test")
    func test_builder() async throws {
        let element = Span { "This is a test" }
        let output = element.render(context: publishingContext)

        #expect(output == "<span>This is a test</span>")
    }
}
