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
class OpacityTests: IgniteTestSuite {
    @Test("Text Opacity", arguments: ["This is a test", "Another test"])
    func textOpacity(text: String) async throws {
        let element = Text(text).opacity(0.5)
        let output = element.render()

        #expect(output == "<p style=\"opacity: 0.5\">\(text)</p>")
    }

    @Test("Image Opacity", arguments: [(path: "/images/example.jpg", description: "Example image")])
    func imageOpacity(image: (path: String, description: String)) async throws {
        let element = Image(image.path, description: image.description).opacity(0.2)
        let output = element.render()

        #expect(output == "<img src=\"\(image.path)\" alt=\"\(image.description)\" style=\"opacity: 0.2\" />")
    }

    @Test("Checks that the opacity value is correctly formatted", arguments: zip(
        [0.123456, 0.15, 0.1, 0.45678, 0],
        ["0.123", "0.15", "0.1", "0.457", "0"]))
    func opacityFormatting(value: Double, css: String) async throws {
        let element = Text("Test").opacity(value)
        let output = element.render()

        #expect(output == "<p style=\"opacity: \(css)\">Test</p>")
    }

    @Test("Checks that full opacity is not rendered")
    func fullOpacity() async throws {
        let element = Text("Test").opacity(1)
        let output = element.render()
        #expect(output == "<p>Test</p>")
    }
}
