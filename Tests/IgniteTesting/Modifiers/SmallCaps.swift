//
//  SmallCaps.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `SmallCaps` modifier.
@Suite("SmallCaps Tests")
@MainActor
class SmallCapsTests: IgniteTestSuite {
    @Test("SmallCaps Modifier")
    func htmlSmallCaps() async throws {
        let element = Span("Hello, World!").smallCaps()
        let output = element.render()

        #expect(output == "<span style=\"font-variant: small-caps\">Hello, World!</span>")
    }
}
