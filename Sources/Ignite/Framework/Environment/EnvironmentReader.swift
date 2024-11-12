//
// EnvironmentReader.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that allows types to read and write environment values.
public protocol EnvironmentReader: Sendable {
    /// The current environment values for this reader.
    @MainActor var environment: EnvironmentValues { get set }
}
