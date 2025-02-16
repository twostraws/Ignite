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
    @Test("Verify AspectRatio Modifiers")
    func verifyAspectRatioModifiers() async throws {
        let testCases: [(AspectRatio, String)] = [
            (.square, "1x1"),
            (.r4x3, "4x3"),
            (.r16x9, "16x9"),
            (.r21x9, "21x9")
        ]

        for (aspectRatio, expectedClass) in testCases {
            let element = Text("Hello").aspectRatio(aspectRatio)
            let output = element.render()

            #expect(output == "<p class=\"ratio ratio-\(expectedClass)\">Hello</p>")
        }
    }

    @Test("Verify Content Modes")
    func verifyContentModes() async throws {
        let testCases: [(ContentMode, String)] = [
            (.fit, "object-fit-contain"),
            (.fill, "object-fit-cover")
        ]

        for (contentMode, expectedClass) in testCases {
            let expectedRawValue = contentMode.htmlClass
            #expect(expectedRawValue == expectedClass)
        }
    }

    @Test("Verify Aspect Ratios with Content Modes")
    func verifyAspectRatiosWithContentModes() async throws {
        // swiftlint:disable:next large_tuple
        let testCases: [(AspectRatio, ContentMode, String)] = [
            (.square, .fit, "<div class=\"ratio ratio-1x1\"><i class=\"bi-swift object-fit-contain\"></i></div>"),
            (.r4x3, .fill, "<div class=\"ratio ratio-4x3\"><i class=\"bi-swift object-fit-cover\"></i></div>")
        ]

        for (aspectRatio, contentMode, expectedOutput) in testCases {
            let element = Image(systemName: "swift").aspectRatio(aspectRatio, contentMode: contentMode)
            let output = element.render()

            #expect(output == expectedOutput)
        }
    }
}
