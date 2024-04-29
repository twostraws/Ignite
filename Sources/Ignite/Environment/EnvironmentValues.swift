//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A collection of shared environment values propagated through
/// an element hierarchy.
/// Note: This needs to be a class so we can wrap it with @Environment.
/// See: https://forums.swift.org/t/question-about-enclosinginstance-function-in-property-wrappers/59206/5
public class EnvironmentValues {
    var values: [AnyHashable: Any] = [:]

    public subscript<T>(_ keyPath: WritableKeyPath<EnvironmentValues, T>) -> T {
        get {
            if let value = values[keyPath] as? T {
                return value
            } else {
                // Use reflection to access the default value at the key path
                return self[keyPath: keyPath]
            }
        }
        set {
            values[keyPath] = newValue
        }
    }
}
