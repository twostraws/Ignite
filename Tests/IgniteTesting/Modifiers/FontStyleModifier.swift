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
    private static let tagBasedStyles: [Font.Style] = [
        .title1, .title2, .title3, .title4, .title5, .title6, .body
    ]

    @Test("Font Style", arguments: await tagBasedStyles)
    func fontStyle(style: Font.Style) async throws {
        let element = Text("Hello").font(style)
        let output = element.markupString()
        #expect(output == "<\(style.description)>Hello</\(style.description)>")
    }
}
