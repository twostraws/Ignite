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
struct TextDecorationModifierTests{
    @Test("TextDecoration modifier test (None)")
    func textDecorationNone() async throws {
        let element = Span("Hello, World!").textDecoration(.none)
        let output = element.render()

        #expect(output == "<span style=\"text-decoration: none\">Hello, World!</span>")
    }

    @Test("TextDecoration modifier test (Through)")
    func textDecorationThrough() async throws {
        let element = Span("Hello, World!").textDecoration(.through)
        let output = element.render()

        #expect(output == "<span style=\"text-decoration: line-through\">Hello, World!</span>")
    }

    @Test("TextDecoration modifier test (Underline)")
    func textDecorationUnderline() async throws {
        let element = Span("Hello, World!").textDecoration(.underline)
        let output = element.render()

        #expect(output == "<span style=\"text-decoration: underline\">Hello, World!</span>")
    }
}

