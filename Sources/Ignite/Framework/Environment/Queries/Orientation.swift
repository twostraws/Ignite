//
// Orientation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that represents the device's physical orientation.
public enum Orientation: String, QueryType {
    /// Device is in portrait orientation (taller than wide).
    case portrait

    /// Device is in landscape orientation (wider than tall).
    case landscape

    /// The media query key used in CSS selectors.
    public var key: String { "orientation" }

    /// The complete media query string for detecting device orientation.
    public var query: String { "orientation" }
}

public extension QueryType where Self == Orientation {
    /// Creates an orientation query with the specified orientation
    /// - Parameter orientation: The orientation to query for
    /// - Returns: An Orientation query instance
    static func orientation(_ orientation: Orientation) -> Orientation {
        orientation
    }
}
