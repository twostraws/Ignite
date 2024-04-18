//
// Environment.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

fileprivate var values = EnvironmentValues()

@propertyWrapper public struct Environment<Value> {
    var keyPath: WritableKeyPath<EnvironmentValues, Value>

    public init(_ keyPath: WritableKeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    public var wrappedValue: Value {
        get {
            values[keyPath: keyPath]
        }
        set {
            values[keyPath: keyPath] = newValue
        }
    }
}
