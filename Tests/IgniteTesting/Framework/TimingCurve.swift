//
//  TimingCurve.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `TimingCurve`.
@Suite("TimingCurve Tests")
@MainActor
struct TimingCurveTests {
    @Test("CSS output for automatic")
    func automaticCSS() async throws {
        #expect(TimingCurve.automatic.css == "cubic-bezier(0.4, 1.0, 0.0, 1.0)")
    }

    @Test("CSS output for linear")
    func linearCSS() async throws {
        #expect(TimingCurve.linear.css == "linear")
    }

    @Test("CSS output for easeIn")
    func easeInCSS() async throws {
        #expect(TimingCurve.easeIn.css == "ease-in")
    }

    @Test("CSS output for easeOut")
    func easeOutCSS() async throws {
        #expect(TimingCurve.easeOut.css == "ease-out")
    }

    @Test("CSS output for easeInOut")
    func easeInOutCSS() async throws {
        #expect(TimingCurve.easeInOut.css == "ease-in-out")
    }

    @Test("CSS output for spring")
    func springCSS() async throws {
        #expect(TimingCurve.spring(dampingRatio: 0.5, velocity: 0.2).css == "cubic-bezier(0.4, 0.5, 0.2, 1.0)")
    }

    @Test("CSS output for bezier")
    func bezierCSS() async throws {
        #expect(TimingCurve.bezier(x1: 0.1, y1: 0.2, x2: 0.3, y2: 0.4).css == "cubic-bezier(0.1, 0.2, 0.3, 0.4)")
    }

    @Test("CSS output for custom")
    func customCSS() async throws {
        #expect(TimingCurve.custom("my-timing").css == "my-timing")
    }

    @Test("Static factory smooth equals spring(1.0, 0.0)")
    func smoothFactory() async throws {
        #expect(TimingCurve.smooth == .spring(dampingRatio: 1.0, velocity: 0.0))
    }

    @Test("Static factory snappy equals spring(0.85, 0.15)")
    func snappyFactory() async throws {
        #expect(TimingCurve.snappy == .spring(dampingRatio: 0.85, velocity: 0.15))
    }

    @Test("Static factory bouncy equals spring(0.7, 0.3)")
    func bouncyFactory() async throws {
        #expect(TimingCurve.bouncy == .spring(dampingRatio: 0.7, velocity: 0.3))
    }

    @Test("smooth(extraBounce:) reduces damping and increases velocity")
    func smoothExtraBounce() async throws {
        #expect(TimingCurve.smooth(extraBounce: 0.1) == .spring(dampingRatio: 0.9, velocity: 0.1))
    }
}
