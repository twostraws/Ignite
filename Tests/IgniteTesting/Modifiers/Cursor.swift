//
//  Cursor.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Cursor` modifier.
@Suite("Cursor Tests")
@MainActor
class CursorTests: IgniteTestSuite {
    @Test("Cursor Modifier", arguments: Cursor.allCases)
    func cursorModifier(_ cursor: Cursor) async throws {
        let element = Span("Hello, World!").cursor(cursor)
        let output = element.render()

        #expect(output == "<span style=\"cursor: \(cursor.rawValue)\">Hello, World!</span>")
    }

    @Test("Cursor Modifier on Custom Element", arguments: Cursor.allCases)
    func cursorModifier_onCustomElement(_ cursor: Cursor) async throws {
        let element = TestElement().cursor(cursor)
        let output = element.render()
        #expect(output == """
        <div style=\"cursor: \(cursor.rawValue)\">\
        <p>Test Heading!</p>\
        <p>Test Subheading</p>\
        <label>Test Label</label>\
        </div>
        """)
    }
}
