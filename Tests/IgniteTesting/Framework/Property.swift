//
//  Property.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Property` CSS property enum.
@Suite("Property Tests")
@MainActor
struct PropertyTests {
    @Test("Representative raw values match CSS property names", arguments: [
        (Property.color, "color"),
        (.backgroundColor, "background-color"),
        (.fontSize, "font-size"),
        (.padding, "padding"),
        (.margin, "margin"),
        (.display, "display"),
        (.flexDirection, "flex-direction"),
        (.zIndex, "z-index"),
        (.borderRadius, "border-radius"),
        (.textAlign, "text-align"),
        (.animationDuration, "animation-duration"),
        (.gridTemplateColumns, "grid-template-columns")
    ])
    func rawValuesMatchCSSNames(property: Property, expected: String) async throws {
        #expect(property.rawValue == expected)
    }

    @Test("callAsFunction returns rawValue")
    func callAsFunctionReturnsRawValue() async throws {
        #expect(Property.backgroundColor() == "background-color")
        #expect(Property.fontSize() == "font-size")
    }

    @Test("Round-trip from rawValue")
    func roundTripFromRawValue() async throws {
        let property = Property(rawValue: "background-color")
        #expect(property == .backgroundColor)

        let unknown = Property(rawValue: "not-a-real-property")
        #expect(unknown == nil)
    }
}
