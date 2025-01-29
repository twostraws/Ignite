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
@Suite("Color Type Tests")
@MainActor
struct ColorTypeTests {
    @Test("black and white via parameters",
          arguments: zip(
            [Color.black, .white],
            ["0 0 0", "255 255 255"]
          )
    )
    func makeColor(forgroundStyle: Color, rgbValues: String) async throws {
        let coloredText = Text("Hello, world!")
            .foregroundStyle(forgroundStyle)

        let output = coloredText.render()

        #expect(output ==
        """
        <p style="color: rgb(\(rgbValues) / 100%)">Hello, world!</p>
        """
        )
    }

    @Test("Initialize Color with Int values")
    func testInitializeWithIntValues() async throws {
        let color = Color(red: 255, green: 0, blue: 0)
        #expect(color == .red)
        #expect(color.red == 255)
        #expect(color.green == 0)
        #expect(color.blue == 0)
    }

    @Test("Return CSS value of color")
    func testReturnCSSValueOfColor() async throws {
        let red = 255
        let green = 0
        let blue = 0

        let color = Color(red: red, green: green, blue: blue)
        #expect(color.description == "rgb(\(red) \(blue) \(green) / 100%)")
    }

    // TODO: test opacity and remove use of foregroundStyle
}
