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
struct CursorTests {
    @Test("Cursor Modifiers Test", arguments: Cursor.allCases)
    func cursorModifier(_ cursor: Cursor) async throws {
        let element = Span("Hello, World!").cursor(cursor)
        let output = element.render()

        #expect(output == "<span style=\"cursor: \(cursor.rawValue)\">Hello, World!</span>")
    }
}
