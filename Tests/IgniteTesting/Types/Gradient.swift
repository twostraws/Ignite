//
//  Gradient.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Gradient` type.
@Suite("Gradient Tests")
@MainActor
struct GradientTests {
    @Test("linearGradient", arguments: zip(
        [UnitPoint.top, .bottomLeading, .leading],
        [UnitPoint.bottom, .topTrailing, .trailing]))
    func linearGradient(start: UnitPoint, end: UnitPoint) async throws {
        let element = Gradient.linearGradient(colors: .red, .blue, from: start, to: end)
        let angle = Int(start.degrees(to: end))
        let output = element.description

        #expect(output == """
        linear-gradient(\(angle)deg, rgb(255 0 0 / 100%) 0.0%, rgb(0 0 255 / 100%) 100.0%)
        """)
    }

    @Test("radialGradient")
    func radialGradient() async throws {
        let element = Gradient.radialGradient(colors: .red, .blue)
        let output = element.description

        #expect(output == """
        radial-gradient(circle, rgb(255 0 0 / 100%) 0.0%, rgb(0 0 255 / 100%) 100.0%)
        """)
    }

    @Test("conicGradient should default to 0deg")
    func conicGradient() async throws {
        let element = Gradient.conicGradient(colors: .red, .blue)
        let output = element.description

        #expect(output == """
        conic-gradient(from 0deg, rgb(255 0 0 / 100%) 0.0%, rgb(0 0 255 / 100%) 100.0%)
        """)
    }

    @Test("conicGradient should use correct angles", arguments: [45, 90, 180])
    func conicGradient(angle: Int) async throws {
        let element = Gradient.conicGradient(colors: .red, .blue, angle: angle)
        let output = element.description

        #expect(output == """
        conic-gradient(from \(angle)deg, rgb(255 0 0 / 100%) 0.0%, rgb(0 0 255 / 100%) 100.0%)
        """)
    }
}
