//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Image` element.
@Suite("Image Tests")
@MainActor struct ImageTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Image Test")
    func test_named() async throws {
        let element = Image("/images/example.jpg", description: "Example image")
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<img alt=\"Example image\" src=\"/images/example.jpg\"/>")
    }
    @Test("Icon Image Test")
    func test_icon() async throws {
        let element = Image(
            systemName: "browser-safari", description: "Safari logo")
        let output = element.render(context: publishingContext)

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
