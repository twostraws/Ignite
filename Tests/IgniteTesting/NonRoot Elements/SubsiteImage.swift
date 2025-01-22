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

    @Test("Image Test", arguments: ["/images/example.jpg"], ["Example image"])
    func fileImage(imageFile: String, description: String) async throws {
        let element = Image(imageFile, description: description)
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)
        #expect(
            normalizedOutput
                == "<img alt=\"\(description)\" src=\"/subsite\(imageFile)\"/>")
    }
    @Test("Icon Test", arguments: ["browser-safari"], ["Safari logo"])
    func iconImage(systemName: String, description: String) async throws {
        let element = Image(
            systemName: systemName, description: description)
        let output = element.render(context: publishingContext)

        #expect(output == "<i class=\"bi-\(systemName)\"></i>")
    }
}
