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

    @Test("Image Test", arguments: ["/images/example.jpg"], ["Example image"])
    func test_named(image: String, description: String) async throws {
        let element = Image(image, description: description)
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<img alt=\"Example image\" src=\"/images/example.jpg\"/>")
    }
    @Test("Icon Image Test", arguments: ["browser-safari"], ["Safari logo"])
    func test_icon(systemName: String, description: String) async throws {
        let element = Image(
            systemName: systemName, description: description)
        let output = element.render(context: publishingContext)

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
