//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

@propertyWrapper
public struct Environment<Value> {
    var keyPath: KeyPath<EnvironmentValues, Value>

    init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public static subscript<T: PageElement>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: WritableKeyPath<EnvironmentValues, Value>,
        storage storageKeyPath: WritableKeyPath<T, Self>
    ) -> Value {
        get {
            instance.attributes.environment[wrappedKeyPath]
        }

        set {
            instance.attributes.environment[wrappedKeyPath] = newValue
        }
    }
}
