//
//  LetterSpacing.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `LetterSpacing` modifier.
@Suite("LetterSpacing Tests")
class LetterSpacingTests: IgniteTestSuite {
    @Test("letterSpacing with pixel value adds px unit", .publishingContext())
    func pixelValue() async throws {
        let element = Text("Spaced")
            .letterSpacing(5)

        let output = element.markupString()

        #expect(output.contains("letter-spacing: 5px"))
    }

    @Test("letterSpacing with rem LengthUnit adds rem unit", .publishingContext())
    func remValue() async throws {
        let element = Text("Spaced")
            .letterSpacing(.rem(1.5))

        let output = element.markupString()

        #expect(output.contains("letter-spacing: 1.5rem"))
    }

    @Test("letterSpacing works on inline elements with pixel value", .publishingContext())
    func inlinePixelValue() async throws {
        let element = Emphasis("Spaced")
            .letterSpacing(3)

        let output = element.markupString()

        #expect(output.contains("letter-spacing: 3px"))
    }

    @Test("letterSpacing works on inline elements with LengthUnit", .publishingContext())
    func inlineLengthUnit() async throws {
        let element = Emphasis("Spaced")
            .letterSpacing(.rem(2))

        let output = element.markupString()

        #expect(output.contains("letter-spacing: 2.0rem"))
    }
}
