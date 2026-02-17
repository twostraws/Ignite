//
//  FontWeightModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FontWeightModifier` modifier.
@Suite("FontWeightModifier Tests")
@MainActor
class FontWeightModifierTests: IgniteTestSuite {
    @Test("Font Weight Modifier", arguments: Font.Weight.allCases)
    func fontWeight(weight: Font.Weight) async throws {
        let element = Text("Hello").fontWeight(weight)
        let output = element.markupString()
        #expect(output == "<p style=\"font-weight: \(weight.rawValue)\">Hello</p>")
    }

    @Test("Font weight on inline element applies style")
    func fontWeightOnInlineElement() async throws {
        let element = Span("Bold text").fontWeight(.bold)
        let output = element.markupString()
        #expect(output.contains("font-weight: 700"))
    }
}
