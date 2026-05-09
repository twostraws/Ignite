//
//  Animation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `Animation`.
@Suite("Animation Tests")
struct AnimationTests {
    @Test("Default values are correct", .publishingContext())
    func defaultValues() async throws {
        let animation = Animation()
        #expect(animation.direction == .automatic)
        #expect(animation.fillMode == .none)
        #expect(animation.repeatCount == 1)
        #expect(animation.delay == 0)
        #expect(animation.timing == .easeInOut)
        #expect(animation.duration == 1)
    }

    @Test("with() applies a duration option", .publishingContext())
    func withAppliesDuration() async throws {
        var animation = Animation()
        animation.with([.duration(2.0)])
        #expect(animation.duration == 2.0)
    }

    @Test("with() uses last-wins for duplicate option types", .publishingContext())
    func withLastWins() async throws {
        var animation = Animation()
        animation.with([.duration(1), .duration(3)])
        #expect(animation.duration == 3)
    }

    @Test("speed option halves default duration", .publishingContext())
    func speedHalvesDuration() async throws {
        var animation = Animation()
        animation.with([.speed(2)])
        #expect(animation.duration == 0.5)
    }

    @Test("bounce preset has correct duration and frame count", .publishingContext())
    func bouncePreset() async throws {
        let animation = Animation.bounce
        #expect(animation.duration == 0.5)
        #expect(animation.frames.count == 3)
    }

    @Test("wiggle preset has correct duration, repeatCount, and frame count", .publishingContext())
    func wigglePreset() async throws {
        let animation = Animation.wiggle
        #expect(animation.duration == 0.5)
        #expect(animation.repeatCount == 3)
        #expect(animation.frames.count == 5)
    }
}
