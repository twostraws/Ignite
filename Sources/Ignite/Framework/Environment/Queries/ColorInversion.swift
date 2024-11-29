//
// ColorInversion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that represents the user's color inversion preference for media queries.
public enum ColorInversion: String, QueryType {
    /// Colors are inverted from their default appearance.
    case inverted

    /// Colors are displayed in their default state.
    case normal

    /// The media query key used in CSS selectors.
    public var key: String { "inverted-colors" }

    /// The complete media query string for detecting color inversion preferences.
    public var query: String { "inverted-colors" }
}

// MARK: - ColorInversion Static Extensions
public extension QueryType where Self == ColorInversion {
    /// Creates a color inversion query with the specified mode
    /// - Parameter inversion: The color inversion to query for
    /// - Returns: A ColorInversion query instance
    static func colorInversion(_ inversion: ColorInversion) -> ColorInversion {
        inversion
    }
}
