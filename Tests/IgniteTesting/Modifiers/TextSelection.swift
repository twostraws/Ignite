//
//  TextSelection.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `TextSelection` modifier.
@Suite("TextSelection Tests")
@MainActor
struct TextSelectionTests {
    @Test("Automatic Text Selection")
    func automaticTextSelection() async throws {
        let element = Text("Hello").textSelection(.automatic)
        let output = element.render()

        #expect(output == "<p class=\"user-select-automatic\">Hello</p>")
    }

    @Test("All Text Selection")
    func allTextSelection() async throws {
        let element = Text("Hello").textSelection(.all)
        let output = element.render()

        #expect(output == "<p class=\"user-select-all\">Hello</p>")
    }

    @Test("None Text Selection")
    func noneTextSelection() async throws {
        let element = Text("Hello").textSelection(.none)
        let output = element.render()

        #expect(output == "<p class=\"user-select-none\">Hello</p>")
    }
}
