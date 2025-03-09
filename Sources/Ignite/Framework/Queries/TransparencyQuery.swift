//
// Untitled.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Applies styles based on the user's transparency preferences.
public enum TransparencyQuery: String, Query, CaseIterable {
    /// Reduced transparency preference
    case reduced = "prefers-reduced-transparency: reduce"
    /// Standard transparency preference
    case normal = "prefers-reduced-transparency: no-preference"

    public var condition: String { rawValue }
}

extension TransparencyQuery: MediaFeature {
    public var description: String {
        rawValue
    }
}
