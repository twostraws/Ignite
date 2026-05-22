//
//  AnimationDirection.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `AnimationDirection`.
@Suite("AnimationDirection Tests")
struct AnimationDirectionTests {
    @Test("Raw values match CSS animation-direction values", .publishingContext(), arguments: zip(
        [AnimationDirection.automatic, .reverse, .alternate, .alternateReverse],
        ["normal", "reverse", "alternate", "alternate-reverse"]))
    func rawValues(direction: AnimationDirection, expected: String) async throws {
        #expect(direction.rawValue == expected)
    }

    @Test("Hashable conformance: equal values hash the same", .publishingContext())
    func hashableConformance() async throws {
        let a = AnimationDirection.alternate
        let b = AnimationDirection.alternate
        #expect(a.hashValue == b.hashValue)
    }
}
