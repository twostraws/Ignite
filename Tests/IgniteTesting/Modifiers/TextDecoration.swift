//
//  TextDecoration.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `TextDecoration` modifier.
@Suite("TextDecoration Tests")
class TextDecorationModifierTests: IgniteTestSuite {
    @Test("Text Decoration Modifier", .publishingContext(), arguments: TextDecoration.allCases)
    func textDecorationNone(_ decoration: TextDecoration) async throws {
        let element = Span("Hello, World!").textDecoration(decoration)
        let output = element.markupString()

        #expect(output == "<span style=\"text-decoration: \(decoration.rawValue)\">Hello, World!</span>")
    }

    @Test("Text decoration on HTML element applies style", .publishingContext())
    func textDecorationOnHTMLElement() async throws {
        let element = Text("Styled").textDecoration(.underline)
        let output = element.markupString()
        #expect(output.contains("text-decoration: underline"))
    }
}
