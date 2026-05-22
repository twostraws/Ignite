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
struct ColorAreaTests {
    @Test("Foreground maps to color property", .publishingContext())
    func foregroundProperty() async throws {
        #expect(ColorArea.foreground.property == .color)
    }

    @Test("Background maps to backgroundColor property", .publishingContext())
    func backgroundProperty() async throws {
        #expect(ColorArea.background.property == .backgroundColor)
    }
}
