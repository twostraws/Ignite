//
//  FixedSize.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FixedSize` modifier.
@Suite("FixedSize Tests")
@MainActor
struct FixedSizeTests {
    @Test("FixedSize Modifier")
    func fixedSizeModifier() async throws {
        let element = Text("Hello").fixedSize()
        let output = element.render()
        #expect(
            output == "<div style=\"display: inline-block\"><p>Hello</p></div>"
        )
    }
}
