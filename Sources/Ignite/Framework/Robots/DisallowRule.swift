//
// DisallowRule.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A rule that disallows one specific robot from one or more paths on your site.
public struct DisallowRule {
    var name: String
    var paths: [String]

    public init(name: String, paths: [String]) {
        self.name = name
        self.paths = paths
    }

    public init(name: String) {
        self.name = name
        self.paths = ["*"]
    }

    public init(robot: KnownRobot, paths: [String]) {
        self.name = robot.rawValue
        self.paths = paths
    }

    public init(robot: KnownRobot) {
        self.name = robot.rawValue
        self.paths = ["*"]
    }
}
