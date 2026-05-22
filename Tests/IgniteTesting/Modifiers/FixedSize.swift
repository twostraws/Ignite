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
class FixedSizeTests: IgniteTestSuite {
    @Test("FixedSize Modifier", .publishingContext())
    func fixedSizeModifier() async throws {
        let element = Text("Hello").fixedSize()
        let output = element.markupString()
        #expect(output == "<div style=\"display: inline-block\"><p>Hello</p></div>")
    }
}
