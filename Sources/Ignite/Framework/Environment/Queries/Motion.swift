//
// Motion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents the user's motion preference for animations.
public enum Motion: String, QueryType {
    /// User prefers reduced motion for animations.
    case reduced

    /// User accepts standard motion animations.
    case normal

    /// The media query key used in CSS selectors.
    public var key: String { "motion" }

    /// The complete media query string for detecting motion preferences.
    public var query: String { "prefers-reduced-motion" }
}

public extension QueryType where Self == Motion {
    /// Creates a motion query with the specified preference
    /// - Parameter motion: The motion preference to query for
    /// - Returns: A Motion query instance
    static func motion(_ motion: Motion) -> Motion {
        motion
    }
}
