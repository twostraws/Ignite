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
        let output = element.render()
        #expect(output == "<p style=\"font-weight: \(weight.rawValue)\">Hello</p>")
    }
}
