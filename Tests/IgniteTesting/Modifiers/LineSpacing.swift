//
//  LineSpacing.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `LineSpacing` modifier.
@Suite("LineSpacing Tests")
@MainActor
struct LineSpacingTests {
    @Test("Custom Line Spacing", arguments: zip([2.5, 0.0, -2.0], ["2.5", "0", "-2"]))
    func lineSpacing(value: Double, expected: String) async throws {
        let element = Text("Hello, world!").lineSpacing(value)
        let output = element.render()

        #expect(output == "<p style=\"line-height: \(expected)\">Hello, world!</p>")
    }

    @Test("Preset Line Spacing", arguments: LineSpacing.allCases)
    func lineSpacing(spacing: LineSpacing) async throws {
        let element = Text("Hello, world!").lineSpacing(spacing)
        let output = element.render()

        #expect(output == "<p class=\"lh-\(spacing.rawValue)\">Hello, world!</p>")
    }
}
