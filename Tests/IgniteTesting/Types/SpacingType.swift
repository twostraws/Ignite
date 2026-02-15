//
//  SpacingType.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `SpacingType` type.
@Suite("SpacingType Tests")
@MainActor
struct SpacingTypeTests {
    @Test("Exact values are equatable")
    func exactValuesAreEquatable() async throws {
        #expect(SpacingType.exact(10) == SpacingType.exact(10))
        #expect(SpacingType.exact(0) == SpacingType.exact(0))
        #expect(SpacingType.exact(10) != SpacingType.exact(20))
    }

    @Test("Semantic values are equatable")
    func semanticValuesAreEquatable() async throws {
        #expect(SpacingType.semantic(.medium) == SpacingType.semantic(.medium))
        #expect(SpacingType.semantic(.small) != SpacingType.semantic(.large))
    }

    @Test("Automatic equals automatic")
    func automaticEqualsAutomatic() async throws {
        #expect(SpacingType.automatic == SpacingType.automatic)
    }

    @Test("Different variants are not equal")
    func differentVariantsAreNotEqual() async throws {
        #expect(SpacingType.exact(0) != SpacingType.automatic)
        #expect(SpacingType.exact(0) != SpacingType.semantic(.none))
        #expect(SpacingType.automatic != SpacingType.semantic(.none))
    }
}
