//
//  Color.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Color` type.
@Suite("Tests for the `Color` type")
@MainActor
struct ColorTypeTests {
    @Test("CSS values via parameters", arguments: zip(
        [Color.black, .white],
        ["0 0 0", "255 255 255"]))
    func makeColor(color: Color, rgbValues: String) async throws {
        #expect(color.description == "rgb(" + rgbValues + " / 100%)")
    }

    @Test("Color init with Int values")
    func testInitializeWithIntValues() async throws {
        let color = Color(red: 255, green: 0, blue: 0)
        #expect(color == .red)
        #expect(color.red == 255)
        #expect(color.green == 0)
        #expect(color.blue == 0)
    }

    @Test("CSS color value")
    func testReturnCSSValueOfColor() async throws {
        let red = 255
        let green = 0
        let blue = 0
        let color = Color(red: red, green: green, blue: blue)

        #expect(color.description == "rgb(\(red) \(blue) \(green) / 100%)")
    }

    @Test("Opacity")
    func testReturnCSSColorValueWithOpacity() async throws {
        let red = 255
        let green = 0
        let blue = 0
        let opacity = 50%
        let color = Color(red: red, green: green, blue: blue, opacity: opacity)

        #expect(color.description == "rgb(\(red) \(blue) \(green) / \(opacity.roundedValue)%)")
    }
}
