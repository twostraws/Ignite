//
// Title.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

/// Tests for the `title` element.
@MainActor final class TitleTests: ElementTest {
    func test_empty() {
        let element = Title("")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<title> - My Test Site</title>")
    }

    func test_builder() {
        let element = Title("Example Page")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<title>Example Page - My Test Site</title>")
    }
}
