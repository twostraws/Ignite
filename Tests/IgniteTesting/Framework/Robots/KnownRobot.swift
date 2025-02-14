//
// KnownRobot.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `KnownRobot`.
@Suite("KnownRobot Tests")
@MainActor
struct KnownRobotTests {
    @Test("All KnownRobot cases", arguments: zip(
        KnownRobot.allCases, [
            "Applebot",
            "baiduspider",
            "bingbot",
            "GPTBot",
            "CCBot",
            "Googlebot",
            "slurp",
            "yandex"
        ]
    ))
    func allKnowRobots(robot: KnownRobot, expectedName: String) async throws {
        #expect(robot.rawValue == expectedName)
    }
}
