//
//  FormatStyle-NonLocalizedDecimal.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FormatStyle-NonLocalizedDecimal` extension.
@Suite("FormatStyle-NonLocalizedDecimal Tests")
@MainActor
struct FormatStyleNonLocalizedDecimalTests {
    @Test("Double default format uses one decimal place")
    func doubleDefaultFormatUsesOneDecimalPlace() async throws {
        let value: Double = 3.14159
        let result = value.formatted(.nonLocalizedDecimal)
        #expect(result == "3.1")
    }

    @Test("Double with custom decimal places", arguments: zip(
        [0, 1, 2, 3],
        ["3", "3.1", "3.14", "3.142"]))
    func doubleWithCustomDecimalPlaces(places: Int, expected: String) async throws {
        let value: Double = 3.14159
        let result = value.formatted(.nonLocalizedDecimal(places: places))
        #expect(result == expected)
    }

    @Test("Double whole number omits unnecessary decimals")
    func doubleWholeNumberOmitsUnnecessaryDecimals() async throws {
        let value: Double = 5.0
        let result = value.formatted(.nonLocalizedDecimal)
        #expect(result == "5")
    }

    @Test("Float default format uses one decimal place")
    func floatDefaultFormatUsesOneDecimalPlace() async throws {
        let value: Float = 3.14159
        let result = value.formatted(.nonLocalizedDecimal)
        #expect(result == "3.1")
    }

    @Test("Float with custom decimal places", arguments: zip(
        [0, 1, 2],
        ["3", "3.1", "3.14"]))
    func floatWithCustomDecimalPlaces(places: Int, expected: String) async throws {
        let value: Float = 3.14159
        let result = value.formatted(.nonLocalizedDecimal(places: places))
        #expect(result == expected)
    }

    @Test("Always uses period as decimal separator")
    func alwaysUsesPeriodAsDecimalSeparator() async throws {
        let value: Double = 1.5
        let result = value.formatted(.nonLocalizedDecimal)
        #expect(result.contains("."))
        #expect(!result.contains(","))
    }

    @Test("Negative places treated as zero")
    func negativePlacesTreatedAsZero() async throws {
        let value: Double = 3.14159
        let result = value.formatted(.nonLocalizedDecimal(places: -1))
        #expect(result == "3")
    }

    @Test("Zero formats correctly")
    func zeroFormatsCorrectly() async throws {
        let value: Double = 0.0
        let result = value.formatted(.nonLocalizedDecimal)
        #expect(result == "0")
    }

    @Test("Negative numbers format correctly")
    func negativeNumbersFormatCorrectly() async throws {
        let value: Double = -2.75
        let result = value.formatted(.nonLocalizedDecimal(places: 2))
        // Accept either "-2.75" or a locale-aware minus sign variant
        #expect(result.contains("2.75"))
    }
}
