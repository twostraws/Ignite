//
//  ColorScheme.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ColorScheme` type.
@Suite("ColorScheme Tests")
struct ColorSchemeTests {
    @Test("Raw values", .publishingContext(), arguments: zip(
        [ColorScheme.light, .dark],
        ["light", "dark"]))
    func rawValues(scheme: ColorScheme, expected: String) async throws {
        #expect(scheme.rawValue == expected)
    }

    @Test("All cases count is two", .publishingContext())
    func allCasesCountIsTwo() async throws {
        #expect(ColorScheme.allCases.count == 2)
    }

    @Test("Equatable and Hashable conformance", .publishingContext())
    func equatableAndHashableConformance() async throws {
        #expect(ColorScheme.light == ColorScheme.light)
        #expect(ColorScheme.dark == ColorScheme.dark)
        #expect(ColorScheme.light != ColorScheme.dark)

        let set: Set<ColorScheme> = [.light, .dark, .light]
        #expect(set.count == 2)
    }
}
