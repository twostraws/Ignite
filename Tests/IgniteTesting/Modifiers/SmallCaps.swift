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
class SmallCapsTests: IgniteTestSuite {
    @Test("SmallCaps Modifier", .publishingContext())
    func htmlSmallCaps() async throws {
        let element = Span("Hello, World!").smallCaps()
        let output = element.markupString()

        #expect(output == "<span style=\"font-variant: small-caps\">Hello, World!</span>")
    }
}
