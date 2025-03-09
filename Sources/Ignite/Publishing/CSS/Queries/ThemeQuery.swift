//
// ThemeQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Applies styles based on the current theme.
public struct ThemeQuery: Query {
    /// The theme identifier
    let theme: any Theme.Type

    public init(_ theme: any Theme.Type) {
        self.theme = theme
    }

    public var condition: String {
        "data-bs-theme^=\"\(theme.idPrefix)\""
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(theme.idPrefix)
    }

    nonisolated public static func == (lhs: ThemeQuery, rhs: ThemeQuery) -> Bool {
        lhs.theme.idPrefix == rhs.theme.idPrefix
    }
}
