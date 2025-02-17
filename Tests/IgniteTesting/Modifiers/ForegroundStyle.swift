//
//  ForegroundStyle.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ForegroundStyle` modifier.
@Suite("ForegroundStyle Tests")
@MainActor
class ForegroundStyleTests: IgniteTestSuite {
    static let testColorNames = ["white", "black", "red", "green", "blue"]
    static let testColors: [Color] = [.white, .black, .red, .green, .blue]

    static let testRGBs = [
        "rgb(255 255 255 / 100%)",
        "rgb(0 0 0 / 100%)",
        "rgb(255 0 0 / 100%)",
        "rgb(0 128 0 / 100%)",
        "rgb(0 0 255 / 100%)"
    ]

    @Test("Common Foreground Styles", arguments: ForegroundStyle.allCases)
    func commonForegroundStyle(style: ForegroundStyle) async throws {
        let element = Text("Hello").foregroundStyle(style)

        let output = element.render()

        #expect(output == "<p class=\"\(style.rawValue)\">Hello</p>")
    }

    @Test("Color Foreground Styles", arguments: await zip(Self.testColors, Self.testRGBs))
    func colorForegroundStyle(color: Color, value: String) async throws {
        let element = Text("Hello").foregroundStyle(color)

        let output = element.render()

        #expect(output == "<p style=\"color: \(value)\">Hello</p>")
    }

    @Test("String Foreground Styles", arguments: await Self.testColorNames)
    func stringForegroundStyle(string: String) async throws {
        let element = Text("Hello").foregroundStyle(string)

        let output = element.render()

        #expect(output == "<p style=\"color: \(string)\">Hello</p>")
    }
}
