//
//  AnimatableProperty.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `AnimatableProperty`.
@Suite("AnimatableProperty Tests")
@MainActor
struct AnimatablePropertyTests {
    @Test("Raw values match CSS property names", arguments: zip(
        [AnimatableProperty.opacity, .backgroundColor, .transform, .color,
         .width, .zIndex, .letterSpacing],
        ["opacity", "background-color", "transform", "color",
         "width", "z-index", "letter-spacing"]))
    func rawValues(property: AnimatableProperty, expected: String) async throws {
        #expect(property.rawValue == expected)
    }
}
