//
// Environment.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

var environmentValues = EnvironmentValues()

@propertyWrapper public struct Environment<Value> {
    var keyPath: KeyPath<EnvironmentValues, Value>

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    public var wrappedValue: Value {
        get { environmentValues[keyPath: keyPath] }
        set { }
    }
}
