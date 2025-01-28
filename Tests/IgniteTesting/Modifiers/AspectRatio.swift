//
//  AspectRatio.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `AspectRatio` modifier.
@Suite("AspectRatio Tests")
@MainActor
struct AspectRatioTests {
    @Test("Verify AspectRatios")
    func verifyAspectRatios() async throws {
        let expectedValues: [AspectRatio] = [.square, .r4x3, .r16x9, .r21x9]

        let expectedRawValues = expectedValues.map { $0.rawValue }
        let actualRawValues = ["1x1", "4x3", "16x9", "21x9"]

        #expect(expectedRawValues == actualRawValues)
    }

    @Test("Verify ContentMode")
    func verifyContentModes() async throws {
        let expectedValues: [ContentMode] = [.fit, .fill]

        let expectedRawValues = expectedValues.map { $0.htmlClass }
        let actualRawValues = ["object-fit-contain", "object-fit-cover"]

        #expect(expectedRawValues == actualRawValues)
    }

    @Test("Verify .square")
    func verifySquareModifier() async throws {
        let element = Text("Hello").aspectRatio(.square)
        let output = element.render()

        #expect(output == "<p class=\"ratio ratio-1x1\">Hello</p>")
    }

    @Test("Verify .r4x3")
    func verifyR4x3Modifier() async throws {
        let element = Text("Hello").aspectRatio(.r4x3)
        let output = element.render()

        #expect(output == "<p class=\"ratio ratio-4x3\">Hello</p>")
    }

    @Test("Verify .r16x9")
    func verifyR16x9Modifier() async throws {
        let element = Text("Hello").aspectRatio(.r16x9)
        let output = element.render()

        #expect(output == "<p class=\"ratio ratio-16x9\">Hello</p>")
    }

    @Test("Verify .r21x9")
    func verifyR21x9Modifier() async throws {
        let element = Text("Hello").aspectRatio(.r21x9)
        let output = element.render()

        #expect(output == "<p class=\"ratio ratio-21x9\">Hello</p>")
    }


    @Test("Verify Aspect Percentage")
    func verifyAspectPercentage() async throws {
        let element = Text("Hello").aspectRatio(20.0)
        let output = element.render()

        #expect(output == "<p class=\"ratio\" style=\"--bs-aspect-ratio: 5.0%\">Hello</p>")
    }

    @Test("Verify Aspect Square with Fit")
    func verifyAspectSquareWithFit() async throws {
        let element = Image(systemName: "swift").aspectRatio(.square, contentMode: .fit)
        let output = element.render()

        #expect(output == "<div class=\"ratio ratio-1x1\"><i class=\"bi-swift object-fit-contain\"></i></div>")
    }

//    @Test("Verify Aspect R4x3 with Fill")
//    func verifyAspectR4x3WithFill() async throws {
//        let element = Image(systemName: "swift").aspectRatio(.r4x3, contentMode: .fill)
//        let output = element.render()
//
//        #expect(output == "<div class=\"ratio ratio-4x3\"><i class=\"bi-swift object-fill-contain\"></i></div>")
//    }
}
