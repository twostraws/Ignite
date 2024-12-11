//
// Contrast.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents the user's contrast preference for media queries.
public enum Contrast: String, QueryType {
    /// Higher contrast between foreground and background colors.
    case more
    
    /// Lower contrast between foreground and background colors.
    case less
    
    /// Default system contrast settings.
    case normal
    
    /// The media query key used in CSS selectors.
    public var key: String { "contrast" }
    
    /// The complete media query string for detecting contrast preferences.
    public var query: String { "prefers-contrast" }
}

public extension QueryType where Self == Contrast {
    /// Creates a contrast query with the specified level
    /// - Parameter contrast: The contrast level to query for
    /// - Returns: A Contrast query instance
    static func contrast(_ contrast: Contrast) -> Contrast {
        contrast
    }
}
