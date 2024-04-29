//
// EnvironmentKey.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A key for accessing shared values in the environment.
public protocol EnvironmentKey: Hashable {
    associatedtype Value
    static var defaultValue: Value { get }
}
