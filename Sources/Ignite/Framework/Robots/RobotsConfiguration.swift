//
// RobotsConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A simple protocol that lets users create custom robot configurations easily.
public protocol RobotsConfiguration {
    var disallowRules: [DisallowRule] { get }
}
