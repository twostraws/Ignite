//
//  DoubleClickModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `DoubleClickModifier` modifier.
@Suite("DoubleClickModifier Tests")
@MainActor
class DoubleClickModifierTests: IgniteTestSuite {
    @Test("onDoubleClick adds ondblclick attribute to HTML element")
    func onDoubleClickAddsAttribute() async throws {
        let element = Text("Double tap me")
            .onDoubleClick { ShowAlert(message: "Double") }

        let output = element.markupString()

        #expect(output.contains(#"ondblclick="alert('Double')"#))
    }

    @Test("onDoubleClick adds ondblclick attribute to inline element")
    func onDoubleClickInlineElement() async throws {
        let element = Emphasis("Double click me")
            .onDoubleClick { ShowAlert(message: "Dbl") }

        let output = element.markupString()

        #expect(output.contains(#"ondblclick="alert('Dbl')"#))
    }
}
