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
struct DisallowRuleTests {
    @Test("Initializer with name and paths", .publishingContext())
    func initWithNameAndPaths() {
        let rule = DisallowRule(
            name: "example name",
            paths: ["path/1", "path/2"]
        )
        #expect(rule.name == "example name")
        #expect(rule.paths == ["path/1", "path/2"])
    }

    @Test("Initializer with name", .publishingContext())
    func initWithName() {
        let rule = DisallowRule(name: "example name")
        #expect(rule.name == "example name")
        #expect(rule.paths == ["*"])
    }

    @Test("Initializer with robot and paths", .publishingContext())
    func initWithRobotAndPaths() {
        let robot = KnownRobot.google
        let rule = DisallowRule(
            robot: robot,
            paths: ["path/1", "path/2"]
        )
        #expect(rule.name == robot.rawValue)
        #expect(rule.paths == ["path/1", "path/2"])
    }

    @Test("Initializer with robot", .publishingContext())
    func initWithRobot() {
        let robot = KnownRobot.apple
        let rule = DisallowRule(robot: robot)
        #expect(rule.name == robot.rawValue)
        #expect(rule.paths == ["*"])
    }
}
