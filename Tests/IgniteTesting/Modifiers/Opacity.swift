//
//  Opacity.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Opacity` modifier.
@Suite("Opacity Tests")
@MainActor
class OpacityTests: UITestSuite {
    @Test("Text Opacity Test", arguments: ["This is a test", "Another test"])
    func textOpacity(text: String) async throws {
        let element = Text(text).opacity(0.5)
        let output = element.render()

        #expect(output == "<p style=\"opacity: 0.5\">\(text)</p>")
    }

    @Test("Image Opacity Test", arguments: [(path: "/images/example.jpg", description: "Example image")])
    func imageOpacity(image: (path: String, description: String)) async throws {
        let element = Image(image.path, description: image.description).opacity(0.2)
        let output = element.render()

        #expect(output == "<img alt=\"\(image.description)\" src=\"\(image.path)\" style=\"opacity: 0.2\" />")
    }
}
