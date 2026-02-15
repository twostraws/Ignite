//
//  Rotation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Rotation` type.
@Suite("Rotation Tests")
@MainActor
struct RotationTests {
    @Test("Flip transition maps each rotation to expected axis and degrees", arguments: [
        (rotation: Rotation.right, axis: "Y", degrees: "360deg"),
        (rotation: Rotation.left, axis: "Y", degrees: "-360deg"),
        (rotation: Rotation.up, axis: "X", degrees: "-360deg"),
        (rotation: Rotation.down, axis: "X", degrees: "360deg")
    ])
    func flipTransitionMapping(rotation: Rotation, axis: String, degrees: String) async throws {
        let transition = Transition.flip(rotation)

        #expect(transition.data.count == 1)
        #expect(transition.data[0].property == .transform)
        #expect(transition.data[0].initial == "perspective(400px) rotate\(axis)(0)")
        #expect(transition.data[0].final == "perspective(400px) rotate\(axis)(\(degrees))")
    }

    @Test("Default flip direction matches .right")
    func defaultFlipDirectionIsRight() async throws {
        #expect(Transition.flip().data == Transition.flip(.right).data)
    }
}
