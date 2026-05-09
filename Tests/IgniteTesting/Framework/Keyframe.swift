//
//  Keyframe.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `Keyframe` (aka `Animation.Frame`) and `Animation.InlineStyle`.
@Suite("Keyframe Tests")
struct KeyframeTests {
    @Test("InlineStyle description combines property and value", .publishingContext())
    func inlineStyleDescription() async throws {
        let style = Animation.InlineStyle(.opacity, value: "0.5")
        #expect(style.description == "opacity: 0.5")
    }

    @Test("Keyframe stores position correctly", .publishingContext())
    func keyframePosition() async throws {
        let frame = Keyframe(50%)
        #expect(frame.position == 50%)
    }

    @Test("custom() appends one style", .publishingContext())
    func customAppendsStyle() async throws {
        let frame = Keyframe(50%).custom(.opacity, value: "0")
        #expect(frame.styles.count == 1)
        #expect(frame.styles.first?.property == "opacity")
        #expect(frame.styles.first?.value == "0")
    }

    @Test("scale() appends transform style", .publishingContext())
    func scaleAppendsTransform() async throws {
        let frame = Keyframe(0%).scale(1.5)
        #expect(frame.styles.count == 1)
        #expect(frame.styles.first?.description == "transform: scale(1.5)")
    }

    @Test("rotate() appends transformOrigin and transform styles", .publishingContext())
    func rotateAppendsTwoStyles() async throws {
        let frame = Keyframe(100%).rotate(.degrees(45))
        #expect(frame.styles.count == 2)
        #expect(frame.styles[0].property == "transform-origin")
        #expect(frame.styles[1].property == "transform")
        #expect(frame.styles[1].value == "rotate(45.0deg)")
    }

    @Test("color() appends style with correct property", .publishingContext())
    func colorAppendsStyle() async throws {
        let frame = Keyframe(0%).color(.foreground, to: .white)
        #expect(frame.styles.count == 1)
        #expect(frame.styles.first?.property == "color")
    }
}
