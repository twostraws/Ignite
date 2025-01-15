//
// EnvironmentStore.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A class that manages the storage of environment values.
@MainActor
final class EnvironmentStore {
    /// The current environment values for the application.
    static var current = EnvironmentValues()
}
