//
//  AnimationOption.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `AnimationOption`.
@Suite("AnimationOption Tests")
@MainActor
struct AnimationOptionTests {
    @Test("Hashable conformance: equal values are equal")
    func hashableEquality() async throws {
        #expect(AnimationOption.duration(1.0) == .duration(1.0))
    }

    @Test("Hashable conformance: different values are not equal")
    func hashableInequality() async throws {
        #expect(AnimationOption.duration(1.0) != .duration(2.0))
    }

    @Test("optionType maps each case to its corresponding OptionType")
    func optionTypeMapping() async throws {
        #expect(AnimationOption.repeatCount(1).optionType == .repeatCount)
        #expect(AnimationOption.fillMode(.none).optionType == .fillMode)
        #expect(AnimationOption.direction(.automatic).optionType == .direction)
        #expect(AnimationOption.duration(1).optionType == .duration)
        #expect(AnimationOption.timing(.linear).optionType == .timing)
        #expect(AnimationOption.delay(0).optionType == .delay)
        #expect(AnimationOption.speed(1).optionType == .speed)
    }
}
