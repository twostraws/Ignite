//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest

@testable import Ignite

/// Tests for the `Image` element.
@MainActor final class ImageTests: ElementTest {
    func test_named() {
        let element = Image("/images/example.jpg", description: "Example image")
        let output = element.render(context: publishingContext)
        let normalizedOutput = normalizeHTML(output)

        XCTAssertEqual(
            normalizedOutput,
            "<img alt=\"Example image\" src=\"/images/example.jpg\"/>")
    }

    func test_icon() {
        let element = Image(
            systemName: "browser-safari", description: "Safari logo")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<i class=\"bi-browser-safari\"></i>")
    }
}
