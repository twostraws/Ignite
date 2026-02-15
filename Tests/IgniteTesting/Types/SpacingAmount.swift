//
//  SpacingAmount.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `SpacingAmount` type.
@Suite("SpacingAmount Tests")
@MainActor
struct SpacingAmountTests {
    @Test("Raw values are sequential from zero", arguments: zip(
        SpacingAmount.allCases,
        [0, 1, 2, 3, 4, 5]))
    func rawValuesAreSequentialFromZero(
        amount: SpacingAmount,
        expectedRawValue: Int
    ) async throws {
        #expect(amount.rawValue == expectedRawValue)
    }

    @Test("All cases count is six")
    func allCasesCountIsSix() async throws {
        #expect(SpacingAmount.allCases.count == 6)
    }

    @Test("Cases are in expected order")
    func casesAreInExpectedOrder() async throws {
        let cases = SpacingAmount.allCases
        #expect(cases[0] == .none)
        #expect(cases[1] == .xSmall)
        #expect(cases[2] == .small)
        #expect(cases[3] == .medium)
        #expect(cases[4] == .large)
        #expect(cases[5] == .xLarge)
    }

    @Test("None has raw value zero")
    func noneHasRawValueZero() async throws {
        #expect(SpacingAmount.none.rawValue == 0)
    }
}
