//
// SubsiteImage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Image` element.
@Suite("Subsite Image Tests")
@MainActor struct SubsiteImageTests {
    let publishingContext = ElementTest.publishingSubsiteContext

    @Test("Image Test")
    func test_image_named() async throws {
        let element = Image("/images/example.jpg", description: "Example image")
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)
        #expect(
            normalizedOutput
                == "<img alt=\"Example image\" src=\"/subsite/images/example.jpg\"/>")
    }
    @Test("Icon Test")
    func test_image_icon() async throws {
        let element = Image(
            systemName: "browser-safari", description: "Safari logo")
        let output = element.render(context: publishingContext)

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
