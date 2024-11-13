//
// PlainText.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

/// Tests for plain text.
@MainActor final class PlainTextTests: ElementTest {
    func test_singleElement() {
        let element = "This is a test"
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "This is a test")
    }
}
