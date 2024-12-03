//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents the user's preferred color scheme for media queries.
public enum ColorScheme: String, QueryType {
    /// The light appearance for the interface.
    case light

    /// The dark appearance for the interface.
    case dark

    /// The media query key used in CSS selectors.
    public var key: String { "color-scheme" }

    /// The complete media query string for detecting color scheme preferences.
    public var query: String { "prefers-color-scheme" }
}

public extension QueryType where Self == ColorScheme {
    /// Creates a color scheme query with the specified mode
    /// - Parameter scheme: The color scheme to query for
    /// - Returns: A ColorScheme query instance
    static func colorScheme(_ scheme: ColorScheme) -> ColorScheme {
        scheme
    }
}
