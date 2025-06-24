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
        let output = element.markupString()

        #expect(output == "<p style=\"margin: 20px\">Hello, world!</p>")
    }

    @Test("Margin modifier with custom pixel value", arguments: [40, 0, -40])
    func customPixelMargin(value: Int) async throws {
        let element = Text("Hello, world!").margin(value)
        let output = element.markupString()

        #expect(output == "<p style=\"margin: \(value)px\">Hello, world!</p>")
    }

    @Test("Margin modifier with amount value", arguments: SemanticSpacing.allCases)
    func amountUnitMargin(amount: SemanticSpacing) async throws {
        let element = Text("Hello, world!").margin(amount)
        let output = element.markupString()

        #expect(output == "<p class=\"m-\(amount.rawValue)\">Hello, world!</p>")
    }

    @Test("Margin modifier with length unit",
          arguments: [LengthUnit.rem(2.5), .em(3), .percent(25%), .vw(10%), .vh(30%), .custom("min(5vh, 30px)")])
    func lengthUnitMargin(value: LengthUnit) {
        let element = Text("Hello, world!").margin(value)
        let output = element.markupString()

        #expect(output == "<p style=\"margin: \(value.stringValue)\">Hello, world!</p>")
    }

    @Test("Margin with negative length values",
          arguments: [LengthUnit.rem(-2.5), .em(-3), .percent(-25%), .vw(-10%), .vh(-30%)])
    func negativeMargin(value: LengthUnit) {
        let element = Text("Hello, world!").margin(value)
        let output = element.markupString()

        #expect(output == "<p style=\"margin: \(value.stringValue)\">Hello, world!</p>")
    }

    @Test("Margin on selected sides with default pixels", arguments: zip(
        [Edge.top, .bottom, .leading, .trailing],
        ["margin-top", "margin-bottom", "margin-left", "margin-right"]))
    func selectedEdgeMargin(alignment: Edge, property: String) {
        let element = Text("Hello, world!").margin(alignment)
        let output = element.markupString()

        #expect(output == "<p style=\"\(property): 20px\">Hello, world!</p>")
    }

    @Test("Margin with custom pixel value and multiple edges")
    func customValueAndEdgeMargin() {
        let element = Text("Hello, world!").margin(.top, 25).margin(.leading, 10)
        let output = element.markupString()

        #expect(output == "<p style=\"margin-top: 25px; margin-left: 10px\">Hello, world!</p>")
    }

    @Test("Margin on selected side with specified unit")
    func selectedEdgeMarginWithUnit() {
        let element = Text("Hello, world!").margin(.top, .rem(1.125))
        let output = element.markupString()

        #expect(output == "<p style=\"margin-top: 1.125rem\">Hello, world!</p>")
    }

    @Test("Margin on selected side with specified amount")
    func selectedEdgeMarginWithAmount() {
        let element = Text("Hello, world!").margin(.top, .medium)
        let output = element.markupString()

        #expect(output == "<p class=\"mt-3\">Hello, world!</p>")
    }
}
