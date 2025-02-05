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
struct OpacityTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

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

    @Test("Checks that the opacity value is correctly formatted", arguments: [
        (value: 0.123456, expected: "0.123"),
        (value: 0.15, expected: "0.15"),
        (value: 0.1, expected: "0.1"),
        (value: 0.45678, expected: "0.457"),
        (value: 0, expected: "0")
    ])
    func opacityFormatting(testCase: (value: Double, expected: String)) async throws {
        let element = Text("Test").opacity(testCase.value)
        let output = element.render()

        #expect(output == "<p style=\"opacity: \(testCase.expected)\">Test</p>")
    }

    @Test("Checks that full opacity is not rendered")
    func fullOpacity() async throws {
        let element = Text("Test").opacity(1)
        let output = element.render()

        #expect(output == "<p>Test</p>")
    }
}
