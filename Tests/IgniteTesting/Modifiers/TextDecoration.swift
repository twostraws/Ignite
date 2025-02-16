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
@MainActor
class TextDecorationModifierTests: IgniteTestSuite {
    @Test("Text Decoration Modifier", arguments: TextDecoration.allCases)
    func textDecorationNone(_ decoration: TextDecoration) async throws {
        let element = Span("Hello, World!").textDecoration(decoration)
        let output = element.render()

        #expect(output == "<span style=\"text-decoration: \(decoration.rawValue)\">Hello, World!</span>")
    }

}
