//
//  AnimatableData.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `AnimatableData`.
@Suite("AnimatableData Tests")
@MainActor
struct AnimatableDataTests {
    @Test("Explicit from/to init stores both values and property")
    func explicitFromTo() async throws {
        let data = AnimatableData(.opacity, from: "0", to: "1")
        #expect(data.initial == "0")
        #expect(data.final == "1")
        #expect(data.property == .opacity)
    }

    @Test("Single value init sets opacity default initial to 1")
    func opacityDefault() async throws {
        let data = AnimatableData(.opacity, value: "0.5")
        #expect(data.initial == "1")
        #expect(data.final == "0.5")
    }

    @Test("Single value init sets backgroundColor default initial to transparent")
    func backgroundColorDefault() async throws {
        let data = AnimatableData(.backgroundColor, value: "red")
        #expect(data.initial == "transparent")
        #expect(data.final == "red")
    }

    @Test("Single value init sets color default initial to inherit")
    func colorDefault() async throws {
        let data = AnimatableData(.color, value: "blue")
        #expect(data.initial == "inherit")
        #expect(data.final == "blue")
    }

    @Test("Single value init sets transform default initial to none")
    func transformDefault() async throws {
        let data = AnimatableData(.transform, value: "scale(2)")
        #expect(data.initial == "none")
        #expect(data.final == "scale(2)")
    }

    @Test("Single value init sets other properties default initial to initial")
    func otherPropertyDefault() async throws {
        let data = AnimatableData(.width, value: "100px")
        #expect(data.initial == "initial")
        #expect(data.final == "100px")
    }

    @Test("Default duration is 0.35")
    func defaultDuration() async throws {
        let data = AnimatableData(.opacity, value: "0")
        #expect(data.duration == 0.35)
    }

    @Test("Default delay is 0")
    func defaultDelay() async throws {
        let data = AnimatableData(.opacity, value: "0")
        #expect(data.delay == 0)
    }

    @Test("Default timing is automatic")
    func defaultTiming() async throws {
        let data = AnimatableData(.opacity, value: "0")
        #expect(data.timing == .automatic)
    }

    @Test("Hashable conformance: same values are equal")
    func hashableEquality() async throws {
        let a = AnimatableData(.opacity, from: "0", to: "1")
        let b = AnimatableData(.opacity, from: "0", to: "1")
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Hashable conformance: different values are not equal")
    func hashableInequality() async throws {
        let a = AnimatableData(.opacity, from: "0", to: "1")
        let b = AnimatableData(.opacity, from: "0.5", to: "1")
        #expect(a != b)
    }
}
