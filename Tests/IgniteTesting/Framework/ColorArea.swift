//
//  ColorArea.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `ColorArea`.
@Suite("ColorArea Tests")
@MainActor
struct ColorAreaTests {
    @Test("Foreground maps to color property")
    func foregroundProperty() async throws {
        #expect(ColorArea.foreground.property == .color)
    }

    @Test("Background maps to backgroundColor property")
    func backgroundProperty() async throws {
        #expect(ColorArea.background.property == .backgroundColor)
    }
}
