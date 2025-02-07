//
// HTMLRootElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can exist directly inside a HTML container.
public protocol RootHTML: HTML {}

extension RootHTML {
    /// The current environment values.
    static var environment: EnvironmentValues {
        EnvironmentStore.current
    }
}
