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

    @Test("Double to Int Conversion in init(red:green:blue:opacity:)")
    func rbgaInitWithDouble() {
        let color = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
        #expect(color.description == "rgb(255 255 255 / 100%)")
    }

    @Test("Double to Int Conversion in init(white:opacity:)")
    func whiteAndOpacityInitWithDouble() {
        let color = Color(white: 1.0, opacity: 1.0)
        #expect(color.description == "rgb(255 255 255 / 100%)")
    }

    // MARK: - Hex initializer

    @Test("Hex init with 6-char string parses RGB correctly")
    func hexInitSixChar() async throws {
        let color = Color(hex: "#FF8000")
        #expect(color.red == 255)
        #expect(color.green == 128)
        #expect(color.blue == 0)
        #expect(color.opacity == 100)
    }

    @Test("Hex init with 8-char string parses RGBA correctly")
    func hexInitEightChar() async throws {
        let color = Color(hex: "#FF800032")
        #expect(color.red == 255)
        #expect(color.green == 128)
        #expect(color.blue == 0)
        #expect(color.opacity == 50)
    }

    @Test("Hex init with invalid string falls back to opaque black")
    func hexInitInvalidFallsBackToBlack() async throws {
        let color = Color(hex: "not-a-color")
        #expect(color.red == 0)
        #expect(color.green == 0)
        #expect(color.blue == 0)
        #expect(color.opacity == 100)
    }

    @Test("Hex init without hash prefix falls back to opaque black")
    func hexInitNoHashFallsBackToBlack() async throws {
        let color = Color(hex: "FF0000")
        #expect(color.red == 0)
        #expect(color.green == 0)
        #expect(color.blue == 0)
        #expect(color.opacity == 100)
    }

    // MARK: - Opacity method

    @Test("Opacity method multiplies existing opacity")
    func opacityMethodMultiplies() async throws {
        let color = Color(red: 255, green: 0, blue: 0)
        let faded = color.opacity(0.5)
        #expect(faded.opacity == 50)
        #expect(faded.red == 255)
    }

    // MARK: - Weighted

    @Test("Weighted lightest mixes with 80% white")
    func weightedLightest() async throws {
        let color = Color.red
        let light = color.weighted(.lightest)
        #expect(light.red == 255)
        #expect(light.green == 204)
        #expect(light.blue == 204)
    }

    @Test("Weighted darkest mixes with 80% black")
    func weightedDarkest() async throws {
        let color = Color.red
        let dark = color.weighted(.darkest)
        #expect(dark.red == 50)
        #expect(dark.green == 0)
        #expect(dark.blue == 0)
    }

    // MARK: - Static constants

    @Test("Clear is fully transparent")
    func clearIsFullyTransparent() async throws {
        #expect(Color.clear.red == 0)
        #expect(Color.clear.green == 0)
        #expect(Color.clear.blue == 0)
        #expect(Color.clear.opacity == 0)
    }

    @Test("Aqua and cyan are equal")
    func aquaEqualsCyan() async throws {
        #expect(Color.aqua == Color.cyan)
    }
}
