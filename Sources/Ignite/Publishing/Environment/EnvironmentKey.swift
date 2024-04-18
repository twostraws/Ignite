//
// EnvironmentKey.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

public protocol EnvironmentKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }
}
