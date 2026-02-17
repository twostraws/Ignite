//
//  Shadow.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Shadow` modifier.
@Suite("Shadow Tests")
@MainActor
class ShadowTests: IgniteTestSuite {
    @Test("Shadow Modifier", arguments: [5, 20])
    func shadowRadius(radius: Int) async throws {
        let element = Span("Hello").shadow(radius: radius)
        let output = element.markupString()

        #expect(output == "<span style=\"box-shadow: rgb(0 0 0 / 33%) 0px 0px \(radius)px \">Hello</span>")
    }

    @Test("Shadow with x and y offsets includes offset values")
    func shadowWithOffsets() async throws {
        let element = Span("Hello").shadow(radius: 10, x: 5, y: 3)
        let output = element.markupString()
        #expect(output.contains("5px 3px 10px"))
    }

    @Test("Shadow with custom color uses that color")
    func shadowCustomColor() async throws {
        let element = Span("Hello").shadow(.red, radius: 8)
        let output = element.markupString()
        #expect(output.contains("rgb(255 0 0 / 100%)"))
        #expect(output.contains("8px"))
    }

    @Test("Inner shadow includes inset keyword")
    func innerShadow() async throws {
        let element = Span("Hello").innerShadow(radius: 10)
        let output = element.markupString()
        #expect(output.contains("inset"))
        #expect(output.contains("10px"))
    }

    @Test("Inner shadow with offsets includes offset and inset")
    func innerShadowWithOffsets() async throws {
        let element = Span("Hello").innerShadow(radius: 6, x: 2, y: 4)
        let output = element.markupString()
        #expect(output.contains("2px 4px 6px inset"))
    }

    @Test("Shadow on HTML element works the same as InlineElement")
    func shadowOnHTMLElement() async throws {
        let element = Text("Hello").shadow(radius: 12)
        let output = element.markupString()
        #expect(output.contains("box-shadow"))
        #expect(output.contains("12px"))
    }

    @Test("Inner shadow on HTML element includes inset")
    func innerShadowOnHTMLElement() async throws {
        let element = Text("Hello").innerShadow(radius: 7)
        let output = element.markupString()
        #expect(output.contains("inset"))
    }
}
