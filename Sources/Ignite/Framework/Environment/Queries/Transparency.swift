//
// Transparency.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that represents the user's transparency preference for UI elements.
public enum Transparency: String, QueryType {
    /// User prefers reduced transparency effects.
    case reduced

    /// User accepts standard transparency effects.
    case normal

    /// The media query key used in CSS selectors.
    public var key: String { "transparency" }

    /// The complete media query string for detecting transparency preferences.
    public var query: String { "prefers-reduced-transparency" }
}

public extension QueryType where Self == Transparency {
    /// Creates a transparency query with the specified preference
    /// - Parameter transparency: The transparency preference to query for
    /// - Returns: A Transparency query instance
    static func transparency(_ transparency: Transparency) -> Transparency {
        transparency
    }
}
