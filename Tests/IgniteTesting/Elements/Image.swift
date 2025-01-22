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
    init() {
        try! PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Image Test", arguments: ["/images/example.jpg"], ["Example image"])
    func named(image: String, description: String) async throws {
        let element = Image(image, description: description)
        let output = element.render()
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<img alt=\"Example image\" src=\"/images/example.jpg\"/>")
    }

    @Test("Icon Image Test", arguments: ["browser-safari"], ["Safari logo"])
    func icon(systemName: String, description: String) async throws {
        let element = Image(
            systemName: systemName, description: description)
        let output = element.render()

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
