//
//  FontStyleModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FontStyleModifier` modifier.
@Suite("FontStyleModifier Tests")
@MainActor
class FontStyleModifierTests: IgniteTestSuite {
    @Test("Font Style", arguments: await Font.Style.tagCases)
    func fontStyle(style: Font.Style) async throws {
        let element = Text("Hello").font(style)
        let output = element.render()
        #expect(output == "<\(style.description)>Hello</\(style.description)>")
    }
}
