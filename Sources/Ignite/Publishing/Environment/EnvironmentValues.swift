//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

public struct EnvironmentValues {
    private var everyValue: [ObjectIdentifier: Any] = [:]

    public init() {}

    public subscript<K>(key: K.Type) -> K.Value where K : EnvironmentKey {
        get {
            guard let value = everyValue[ObjectIdentifier(key)] as? K.Value else { return key.defaultValue }
            return value
        }
        set {  everyValue[ObjectIdentifier(key)] = newValue }
    }
}
