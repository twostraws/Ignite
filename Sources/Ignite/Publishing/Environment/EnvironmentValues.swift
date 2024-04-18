//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

/// A collection of environmental values that is propagated during the publishing process.
public struct EnvironmentValues {
    /// Shared singleton internally used by the Ignite package to access Environment Values.
    static var shared = EnvironmentValues()
    
    /// A values store that contains Any value associated with ObjectIdentifier as a key.
    private var everyValue: [ObjectIdentifier: Any] = [:]

    /// Creates an environment values instance.
    public init() {}

    /// Accesses the environment value associated with a custom key.
    ///
    /// Create custom environment values by defining a key
    /// that conforms to the ``EnvironmentKey`` protocol, and then using that
    /// key with the subscript operator of the ``EnvironmentValues`` structure
    /// to get and set a value for that key.
    public subscript<K>(key: K.Type) -> K.Value where K : EnvironmentKey {
        get {
            guard let value = everyValue[ObjectIdentifier(key)] as? K.Value else { return key.defaultValue }
            return value
        }
        set { everyValue[ObjectIdentifier(key)] = newValue }
    }
}
