//
//  Transition.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `Transition`.
@Suite("Transition Tests")
@MainActor
struct TransitionTests {
    @Test("fadeIn has correct property, values, duration, and timing")
    func fadeIn() async throws {
        let transition = Transition.fadeIn
        #expect(transition.data.count == 1)
        let item = transition.data[0]
        #expect(item.property == .opacity)
        #expect(item.initial == "0")
        #expect(item.final == "1")
        #expect(item.duration == 0.35)
        #expect(item.timing == .automatic)
    }

    @Test("fadeOut has correct property and values")
    func fadeOut() async throws {
        let transition = Transition.fadeOut
        let item = transition.data[0]
        #expect(item.property == .opacity)
        #expect(item.initial == "1")
        #expect(item.final == "0")
    }

    @Test("slideIn from leading uses translateX(-100%) to translateX(0)")
    func slideInLeading() async throws {
        let transition = Transition.slideIn(from: .leading)
        let item = transition.data[0]
        #expect(item.property == .transform)
        #expect(item.initial == "translateX(-100%)")
        #expect(item.final == "translateX(0)")
    }

    @Test("slideIn from top uses translateY(-100%) to translateY(0)")
    func slideInTop() async throws {
        let transition = Transition.slideIn(from: .top)
        let item = transition.data[0]
        #expect(item.property == .transform)
        #expect(item.initial == "translateY(-100%)")
        #expect(item.final == "translateY(0)")
    }

    @Test("slideOut to trailing uses translateX(0) to translateX(100%)")
    func slideOutTrailing() async throws {
        let transition = Transition.slideOut(to: .trailing)
        let item = transition.data[0]
        #expect(item.property == .transform)
        #expect(item.initial == "translateX(0)")
        #expect(item.final == "translateX(100%)")
    }

    @Test("scale defaults use scale(0.8) to scale(1.0)")
    func scaleDefaults() async throws {
        let transition = Transition.scale()
        let item = transition.data[0]
        #expect(item.initial == "scale(0.8)")
        #expect(item.final == "scale(1.0)")
    }

    @Test("blur creates filter from blur(0px) to blur(radius)")
    func blurRadius() async throws {
        let transition = Transition.blur(radius: 10)
        let item = transition.data[0]
        #expect(item.property == .filter)
        #expect(item.initial == "blur(0px)")
        #expect(item.final == "blur(10.0px)")
    }

    @Test("flip sets duration to 0.5 and timing to easeInOut")
    func flipDurationAndTiming() async throws {
        let transition = Transition.flip(.right)
        let item = transition.data[0]
        #expect(item.duration == 0.5)
        #expect(item.timing == .easeInOut)
    }

    @Test("speed() halves the last data item's duration")
    func speedModifier() async throws {
        let transition = Transition.fadeIn.speed(2.0)
        #expect(transition.data[0].duration == 0.35 / 2.0)
    }

    @Test("duration() sets the last data item's duration")
    func durationModifier() async throws {
        let transition = Transition.fadeIn.duration(1.0)
        #expect(transition.data[0].duration == 1.0)
    }

    @Test("delay() sets the last data item's delay")
    func delayModifier() async throws {
        let transition = Transition.fadeIn.delay(0.5)
        #expect(transition.data[0].delay == 0.5)
    }

    @Test("Chaining fadeIn and slideIn produces 2 data items")
    func chainingProducesTwoItems() async throws {
        let transition = Transition.fadeIn.slideIn(from: .leading)
        #expect(transition.data.count == 2)
    }
}
