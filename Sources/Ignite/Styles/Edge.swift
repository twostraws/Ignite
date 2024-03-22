//
// Edge.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes edges on an element, e.g. top or leading, along
/// with groups of edges such as "horizontal" (leading *and* trailing).
public struct Edge: OptionSet {
    /// The internal value used to represent this edge.
    public let rawValue: Int

    /// Creates a new `Edge` instance from a raw value integer.
    /// - Parameter rawValue: The internal value for this edge.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// The top edge of an element,
    public static let top = Edge(rawValue: 1 << 0)

    /// The leading edge of an element, i.e. left in left-to-right languages.
    public static let leading = Edge(rawValue: 1 << 1)

    /// The bottom edge of an element.
    public static let bottom = Edge(rawValue: 1 << 2)

    /// The trailing edge of an element, i.e. right in left-to-right languages.
    public static let trailing = Edge(rawValue: 1 << 3)

    /// The leading and trailing edges of an element.
    public static let horizontal: Edge = [.leading, .trailing]

    /// The top and bottom edges of an element.
    public static let vertical: Edge = [.top, .bottom]

    /// All edges of an element.
    public static let all: Edge = [.horizontal, .vertical]
}
