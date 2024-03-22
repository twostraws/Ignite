//
// Title.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `title` element.
final class TitleTests: ElementTest {
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
