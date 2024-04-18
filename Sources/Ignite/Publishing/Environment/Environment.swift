//
// Environment.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

/// A property wrapper that reads a value from a view's environment.
///
/// Use the `Environment` property wrapper to read a value
/// stored in a view's environment. Indicate the value to read using an
/// ``EnvironmentValues`` key path in the property declaration.
///
/// You can use this property wrapper to read --- but not set --- an environment
/// value.
///
@propertyWrapper public struct Environment<Value> {
    /// A key path to a specific resulting value.
    private var keyPath: KeyPath<EnvironmentValues, Value>

    /// Creates an environment property to read the specified key path.
    ///
    /// Don’t call this initializer directly. Instead, declare a property
    /// with the ``Environment`` property wrapper, and provide the key path of
    /// the environment value that the property should reflect:
    ///
    /// - Parameter keyPath: A key path to a specific resulting value.
    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    /// The current value of the environment property.
    ///
    /// The wrapped value property provides primary access to the value's data.
    /// However, you don't access `wrappedValue` directly. Instead, you read the
    /// property variable created with the ``Environment`` property wrapper.
    public var wrappedValue: Value {
        get { EnvironmentValues.shared[keyPath: keyPath] }
        set { }
    }
}
