//
//  Margin.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Margin` modifier.
@Suite("Margin Tests")
@MainActor
struct MarginTests {
    @Test("Default margin applies 20px to all edges")
    func defaultMargin() async throws {
        let element = Text("Hello, world!").margin()
        let output = element.render()

        #expect(output == "<p style=\"margin: 20px\">Hello, world!</p>")
    }

    @Test("Margin modifier with custom pixel value", arguments: [
        (value: 40, expected: "40px"),
        (value: 0, expected: "0px"),
        (value: -40, expected: "-40px")
    ])
    func customPixelMargin(testCase: (value: Int, expected: String)) async throws {
        let element = Text("Hello, world!").margin(testCase.value)
        let output = element.render()

        #expect(output == "<p style=\"margin: \(testCase.expected)\">Hello, world!</p>")
    }

    @Test("Margin modifier with amount value")
    func amountUnitMargin() async throws {
        let element = Text("Hello, world!").margin(.small)
        let output = element.render()

        #expect(output == "<p class=\"m-2\">Hello, world!</p>")
    }

    @Test("Margin modifier with length unit", arguments: [
        (value: LengthUnit.rem(2.5), expected: "2.5rem"),
        (value: LengthUnit.em(3), expected: "3.0em"),
        (value: LengthUnit.percent(25%), expected: "25.0%"),
        (value: LengthUnit.vw(10%), expected: "10.0vw"),
        (value: LengthUnit.vh(30%), expected: "30.0vh")
    ])
    func lengthUnitMargin(testCase: (value: LengthUnit, expected: String)) async throws {
        let element = Text("Hello, world!").margin(testCase.value)
        let output = element.render()

        #expect(output == "<p style=\"margin: \(testCase.expected)\">Hello, world!</p>")
    }

    @Test("Margin with negative length values", arguments: [
        (value: LengthUnit.rem(-2.5), expected: "-2.5rem"),
        (value: LengthUnit.em(-3), expected: "-3.0em"),
        (value: LengthUnit.percent(-25%), expected: "-25.0%"),
        (value: LengthUnit.vw(-10%), expected: "-10.0vw"),
        (value: LengthUnit.vh(-30%), expected: "-30.0vh")
    ])
    func negativeMargin(testCase: (value: LengthUnit, expected: String)) {
        let element = Text("Hello, world!").margin(testCase.value)
        let output = element.render()

        #expect(output == "<p style=\"margin: \(testCase.expected)\">Hello, world!</p>")
    }

    @Test("Margin modifier with custom length unit")
    func customLengthUnitMargin() async throws {
        let element = Text("Hello, world!").margin(.custom("min(60vh, 300px)"))
        let output = element.render()

        #expect(output == "<p style=\"margin: min(60vh, 300px)\">Hello, world!</p>")
    }

    @Test("Margin on selected sides with default pixels", arguments: [
        (value: (Edge.top), expected: "margin-top: 20px"),
        (value: (Edge.bottom), expected: "margin-bottom: 20px"),
        (value: (Edge.leading), expected: "margin-left: 20px"),
        (value: (Edge.trailing), expected: "margin-right: 20px"),
        (value: (Edge.vertical), expected: "margin-bottom: 20px; margin-top: 20px"),
        (value: (Edge.horizontal), expected: "margin-left: 20px; margin-right: 20px")
    ])
    func selectedEdgeMargin(testCase: (value: Edge, expected: String)) {
        let element = Text("Hello, world!").margin(testCase.value)
        let output = element.render()

        #expect(output == "<p style=\"\(testCase.expected)\">Hello, world!</p>")
    }

    @Test("Margin with custom pixel value and multiple edges")
    func customValueAndEdgeMargin() {
        let element = Text("Hello, world!").margin(.top, 25).margin(.leading, 10)
        let output = element.render()

        #expect(output == "<p style=\"margin-left: 10px; margin-top: 25px\">Hello, world!</p>")
    }

    @Test("Margin on selected side with specified unit")
    func selectedEdgeMarginWithUnit() {
        let element = Text("Hello, world!").margin(.top, .rem(1.125))
        let output = element.render()

        #expect(output == "<p style=\"margin-top: 1.125rem\">Hello, world!</p>")
    }

    @Test("Margin on selected side with specified amount")
    func selectedEdgeMarginWithAmount() {
        let element = Text("Hello, world!").margin(.top, .medium)
        let output = element.render()

        #expect(output == "<p class=\"mt-3\">Hello, world!</p>")
    }
}
