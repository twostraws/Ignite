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
    @Test("LineSpacing with custom line height", arguments: [
        (value: 2.5, expected: "2.5"),
        (value: 0.0, expected: "0"),
        (value: -2.0, expected: "-2")
    ])
    func textWithCustomLineSpacing(testCase: (value: Double, expected: String)) async throws {
        let element = Text("Hello, world!").lineSpacing(testCase.value)
        let output = element.render()

        #expect(output == "<p style=\"line-height: \(testCase.expected)\">Hello, world!</p>")
    }

    @Test("LineSpacing with xSmall preset line height")
    func xSmallPresetLineSpacing() async throws {
        let element = Text("Hello, world!").lineSpacing(.xSmall)
        let output = element.render()

        #expect(output == "<p class=\"lh-1\">Hello, world!</p>")
    }

    @Test("LineSpacing with small preset line height")
    func smallPresetLineSpacing() async throws {
        let element = Text("Hello, world!").lineSpacing(.small)
        let output = element.render()

        #expect(output == "<p class=\"lh-sm\">Hello, world!</p>")
    }

    @Test("LineSpacing with small preset line height")
    func standardPresetLineSpacing() async throws {
        let element = Text("Hello, world!").lineSpacing(.standard)
        let output = element.render()

        #expect(output == "<p class=\"lh-base\">Hello, world!</p>")
    }

    @Test("LineSpacing with small preset line height")
    func largePresetLineSpacing() async throws {
        let element = Text("Hello, world!").lineSpacing(.large)
        let output = element.render()

        #expect(output == "<p class=\"lh-lg\">Hello, world!</p>")
    }
}
