//
// PlainText.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for plain text.
final class PlainTextTests: ElementTest {
    func test_singleElement() {
        let element = "This is a test"
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "This is a test")
    }
}
