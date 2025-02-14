//
// DisallowRule.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `DisallowRule`.
@Suite("DisallowRule Tests")
@MainActor
struct DisallowRuleTests {
    @Test("Initializer with name and paths")
    func initWithNameAndPaths() {
        let rule = DisallowRule(
            name: "example name",
            paths: ["path/1", "path/2"]
        )
        #expect(rule.name == "example name")
        #expect(rule.paths == ["path/1", "path/2"])
    }

    @Test("Initializer with name")
    func initWithName() {
        let rule = DisallowRule(name: "example name")
        #expect(rule.name == "example name")
        #expect(rule.paths == ["*"])
    }

    @Test("Initializer with robot and paths")
    func initWithRobotAndPaths() {
        let robot = KnownRobot.google
        let rule = DisallowRule(
            robot: robot,
            paths: ["path/1", "path/2"]
        )
        #expect(rule.name == robot.rawValue)
        #expect(rule.paths == ["path/1", "path/2"])
    }

    @Test("Initializer with robot")
    func initWithRobot() {
        let robot = KnownRobot.apple
        let rule = DisallowRule(robot: robot)
        #expect(rule.name == robot.rawValue)
        #expect(rule.paths == ["*"])
    }
}
