//
//  Padding.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Padding` modifier.
@Suite("Padding Tests")
@MainActor
struct PaddingTests {
    @Test("Default padding applies 20px to all edges")
    func defaultPadding() async throws {
        let element = Text("Hello, world!").padding()
        let output = element.markupString()
        #expect(output == "<p style=\"padding: 20px\">Hello, world!</p>")
    }

    @Test("Custom pixel value", arguments: [40, 0, -10])
    func customPixelValue(value: Int) async throws {
        let element = Text("Hello, world!").padding(value)
        let output = element.markupString()
        #expect(output == "<p style=\"padding: \(value)px\">Hello, world!</p>")
    }

    @Test("Semantic amount", arguments: SpacingAmount.allCases)
    func semanticAmount(amount: SpacingAmount) async throws {
        let element = Text("Hello, world!").padding(amount)
        let output = element.markupString()
        #expect(output == "<p class=\"p-\(amount.rawValue)\">Hello, world!</p>")
    }

    @Test("Length unit", arguments: [
        LengthUnit.rem(2.5), .em(3), .percent(25%), .vw(10%), .vh(30%)
    ])
    func lengthUnit(value: LengthUnit) async throws {
        let element = Text("Hello, world!").padding(value)
        let output = element.markupString()
        #expect(output == "<p style=\"padding: \(value.stringValue)\">Hello, world!</p>")
    }

    @Test("Padding on selected edges with default pixels", arguments: zip(
        [Edge.top, .bottom, .leading, .trailing],
        ["padding-top", "padding-bottom", "padding-left", "padding-right"]))
    func selectedEdge(edge: Edge, property: String) async throws {
        let element = Text("Hello, world!").padding(edge)
        let output = element.markupString()
        #expect(output == "<p style=\"\(property): 20px\">Hello, world!</p>")
    }

    @Test("Padding on selected edge with custom pixel value")
    func selectedEdgeWithCustomPixels() async throws {
        let element = Text("Hello, world!").padding(.top, 25).padding(.leading, 10)
        let output = element.markupString()
        #expect(output == "<p style=\"padding-top: 25px; padding-left: 10px\">Hello, world!</p>")
    }

    @Test("Padding on selected edge with length unit")
    func selectedEdgeWithLengthUnit() async throws {
        let element = Text("Hello, world!").padding(.top, .rem(1.5))
        let output = element.markupString()
        #expect(output == "<p style=\"padding-top: 1.5rem\">Hello, world!</p>")
    }

    @Test("Padding on selected edge with semantic amount")
    func selectedEdgeWithSemanticAmount() async throws {
        let element = Text("Hello, world!").padding(.top, .medium)
        let output = element.markupString()
        #expect(output == "<p class=\"pt-3\">Hello, world!</p>")
    }

    @Test("Horizontal padding applies to leading and trailing")
    func horizontalPadding() async throws {
        let element = Text("Hello, world!").padding(.horizontal)
        let output = element.markupString()
        #expect(output == "<p style=\"padding-left: 20px; padding-right: 20px\">Hello, world!</p>")
    }

    @Test("Vertical padding applies to top and bottom")
    func verticalPadding() async throws {
        let element = Text("Hello, world!").padding(.vertical)
        let output = element.markupString()
        #expect(output == "<p style=\"padding-top: 20px; padding-bottom: 20px\">Hello, world!</p>")
    }
}
