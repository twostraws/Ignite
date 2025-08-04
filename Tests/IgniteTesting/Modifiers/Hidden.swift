//
//  Hidden.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Hidden` modifier.
@Suite("Hidden Tests")
@MainActor
struct HiddenTests {
    @Test("Hidden Modifier for Text")
    func hiddenForText() async throws {
        let element = Text("Hello world!").hidden()
        let output = element.markupString()

        #expect(output == "<p class=\"d-none\">Hello world!</p>")
    }

    @Test("MediaQuery based hidden Modifier for Text")
    func hiddenMediaQueryForText() async throws {
        let className = CSSManager.shared.registerStyles(.init(small: true))
        let element = Text("Hello world!").hidden(.responsive(small: true))
        let output = element.markupString()

        #expect(output == "<p class=\"\(className)\">Hello world!</p>")
    }

    @Test("Hidden Modifier for Column")
    func hiddenForColumn() async throws {
        let element = TableColumn {
            ControlLabel("Left Label")
            ControlLabel("Right Label")
        }.hidden()
        let output = element.markupString()

        #expect(output == "<td colspan=\"1\" class=\"d-none\"><label>Left Label</label><label>Right Label</label></td>")
    }
}
