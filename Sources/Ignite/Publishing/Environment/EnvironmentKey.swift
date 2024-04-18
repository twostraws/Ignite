//
// EnvironmentKey.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

/// A key for accessing values in the environment.
///
/// You can create custom environment values by extending the
/// ``EnvironmentValues`` structure with new properties.
/// First declare a new environment key type and specify a value for the
/// required ``defaultValue`` property.
public protocol EnvironmentKey {
    /// The associated type representing the type of the environment key's value.
    associatedtype Value

    /// The default value for the environment key.
    static var defaultValue: Self.Value { get }
}
