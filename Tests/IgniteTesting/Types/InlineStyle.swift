//
//  InlineStyle.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `InlineStyle` type.
@Suite("InlineStyle Tests")
@MainActor
struct InlineStyleTests {
    @Test("Test correct description for property string initializer.")
    func descriptionPropertyStringInit() async throws {
        let example = InlineStyle("font-size", value: "25px")

        #expect(example.description == "font-size: 25px")
    }

    @Test("Test correct description for property initializer.")
    func descriptionPropertyInit() async throws {
        let example = InlineStyle(Property.fontSize, value: "25px")

        #expect(example.description == "font-size: 25px")
    }

    @Test("Test comparable operator.", arguments: [
        (InlineStyle(.absolutePosition, value: "top"), InlineStyle(.accentColor, value: "red"), true),
        (InlineStyle(.backgroundColor, value: "red"), InlineStyle(.absolutePosition, value: "top"), false),
        (InlineStyle(.textAlign, value: "center"), InlineStyle(.color, value: "red"), false),
        (InlineStyle(.justifyContent, value: "space-between"), InlineStyle(.alignItems, value: "end"), false)
    ])
    func comparable(lhs: InlineStyle, rhs: InlineStyle, expected: Bool) async throws {
        #expect((lhs < rhs) == expected)
        #expect((lhs > rhs) == !expected)
    }
}
