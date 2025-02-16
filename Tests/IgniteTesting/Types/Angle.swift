//
//  Angle.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Angle` type.
@Suite("Angle Tests")
@MainActor
struct AngleTests {
    @Test("Degrees")
    func degreesTest() async throws {
        let angle = Angle.degrees(180)
        let output = angle.value
        #expect(output == "180.0deg")
    }

    @Test("Radians")
    func radiansTest() async throws {
        let angle = Angle.radians(.pi)
        let output = angle.value
        #expect(output == "\(Double.pi)rad")
    }

    @Test("Turns")
    func turnsTest() async throws {
        let angle = Angle.turns(0.5)
        let output = angle.value
        #expect(output == "0.5turn")
    }
}
