//
// ContrastQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Applies styles based on the user's contrast preferences.
public enum ContrastQuery: String, Query, CaseIterable {
    /// Standard contrast preference
    case normal = "prefers-contrast: no-preference"
    /// High contrast preference
    case high = "prefers-contrast: more"
    /// Low contrast preference
    case low = "prefers-contrast: less"

    public var condition: String { rawValue }
}

extension ContrastQuery: MediaFeature {
    public var description: String {
        rawValue
    }
}
