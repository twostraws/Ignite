//
//  ClickModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `ClickModifier` modifier.
@Suite("ClickModifier Tests")
@MainActor
class ClickModifierTests: IgniteTestSuite {
    @Test("onClick adds onclick attribute to HTML element")
    func onClickAddsAttribute() async throws {
        let element = Text("Tap me")
            .onClick { ShowAlert(message: "Hi") }

        let output = element.markupString()

        #expect(output.contains(#"onclick="alert('Hi')"#))
    }

    @Test("onClick adds onclick attribute to inline element")
    func onClickInlineElement() async throws {
        let element = Emphasis("Click me")
            .onClick { ShowAlert(message: "Clicked") }

        let output = element.markupString()

        #expect(output.contains(#"onclick="alert('Clicked')"#))
    }
}
