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
struct AngleTests {
    @Test("Degrees", .publishingContext())
    func degreesTest() async throws {
        let angle = Angle.degrees(180)
        let output = angle.value
        #expect(output == "180.0deg")
    }

    @Test("Radians", .publishingContext())
    func radiansTest() async throws {
        let angle = Angle.radians(.pi)
        let output = angle.value
        #expect(output == "\(Double.pi)rad")
    }

    @Test("Turns", .publishingContext())
    func turnsTest() async throws {
        let angle = Angle.turns(0.5)
        let output = angle.value
        #expect(output == "0.5turn")
    }
}
