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
struct FontStyleModifierTests {
    @Test("Font Style Test")
    func fontStyleExcludingLead() async throws {
        for font in Font.Style.allCases {
            if font != .lead {
                let element = Text("Hello").font(font)

                let output = element.render()

                #expect(
                    output == "<\(font.description)>Hello</\(font.description)>")
            }
        }
    }
}
