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

/// Default implementation that provides access to the current environment values.
/// The environment store maintains global state and settings that can be accessed
/// throughout the page rendering process.
public extension EnvironmentReader {
    @MainActor var environment: EnvironmentValues {
        get { EnvironmentStore.current }
        set { EnvironmentStore.current = newValue }
    }
}
