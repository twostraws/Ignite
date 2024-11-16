//
// DefaultRobotsConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A simple default robots configuration that disallows nothing.
public struct DefaultRobotsConfiguration: RobotsConfiguration {
    public init() { }
    public var disallowRules = [DisallowRule]()
}
