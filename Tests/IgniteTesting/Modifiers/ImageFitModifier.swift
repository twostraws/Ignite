//
// ImageFitModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing
@testable import Ignite

/// Tests for the `ImageFitModifier` modifier.
@Suite("ImageFitModifier Tests")
@MainActor
struct ImageFitModifierTests {
    @Test("Default parameters")
    func testDefaultParameters() async throws {
        let image = Image("/images/example-image.jpg")
        let modifiedImage = image.imageFit()
        let output = modifiedImage.render()

        #expect(output.contains("class=\"w-100 h-100 object-fit-cover\""))
        #expect(output.contains("object-position: 50% 50%"))
    }

    @Test("Custom fit and anchor parameters")
    func testCustomParameters() async throws {
        let image = Image("/images/example-image.jpg")
        let modifiedImage = image.imageFit(.fit, anchor: .bottomLeading)
        let output = modifiedImage.render()

        #expect(output.contains("class=\"w-100 h-100 object-fit-contain\""))
        #expect(output.contains("object-position: 0% 100%"))
    }

    @Test("Different anchor points")
    func testDifferentAnchorPoints() async throws {
        let image = Image("/images/example-image.jpg")
        let topLeftImage = image.imageFit(anchor: .topLeading)
        let topLeftOutput = topLeftImage.render()
        #expect(topLeftOutput.contains("object-position: 0% 0%"))

        let bottomRightImage = image.imageFit(anchor: .bottomTrailing)
        let bottomRightOutput = bottomRightImage.render()
        #expect(bottomRightOutput.contains("object-position: 100% 100%"))
    }
}
