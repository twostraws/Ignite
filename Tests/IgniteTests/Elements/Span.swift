//
// Span.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

/// Tests for the `Span` element.
@MainActor final class SpanTests: ElementTest {
    func test_singleElement() {
        let element = Span("This is a test")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<span>This is a test</span>")
    }

    func test_builder() {
        let element = Span { "This is a test" }
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<span>This is a test</span>")
    }
}
