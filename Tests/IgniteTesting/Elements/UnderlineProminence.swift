//
//  UnderlineProminence.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `UnderlineProminence` type.
@Suite("UnderlineProminence Tests")
@MainActor
struct UnderlineProminenceTests {
    @Test("Raw values match opacity percentages")
    func rawValues() async throws {
        #expect(UnderlineProminence.none.rawValue == 0)
        #expect(UnderlineProminence.faint.rawValue == 10)
        #expect(UnderlineProminence.light.rawValue == 25)
        #expect(UnderlineProminence.medium.rawValue == 50)
        #expect(UnderlineProminence.bold.rawValue == 75)
        #expect(UnderlineProminence.heavy.rawValue == 100)
    }

    @Test("Description formats raw value as string")
    func descriptionFormatsRawValue() async throws {
        #expect(UnderlineProminence.none.description == "0")
        #expect(UnderlineProminence.faint.description == "10")
        #expect(UnderlineProminence.light.description == "25")
        #expect(UnderlineProminence.medium.description == "50")
        #expect(UnderlineProminence.bold.description == "75")
        #expect(UnderlineProminence.heavy.description == "100")
    }

    @Test("Equatable conformance")
    func equatableConformance() async throws {
        #expect(UnderlineProminence.none == UnderlineProminence.none)
        #expect(UnderlineProminence.heavy == UnderlineProminence.heavy)
        #expect(UnderlineProminence.none != UnderlineProminence.heavy)
    }
}
