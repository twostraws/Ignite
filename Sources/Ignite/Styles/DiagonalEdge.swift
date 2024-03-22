//
// DiagonalEdge.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes diagonal edges on an element, e.g. top-leading, or bottom-trailing, along
/// with groups of edges such as "top" (top leading *and* top-trailing).
public struct DiagonalEdge: OptionSet {
    /// The internal value used to represent this edge.
    public let rawValue: Int

    /// Creates a new `DiagonalEdge` instance from a raw value integer.
    /// - Parameter rawValue: The internal value for this edge.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// The top-leading edge of an element, i.e. top-left in left-to-right languages.
    public static let topLeading = DiagonalEdge(rawValue: 1 << 0)

    /// The top-trailing edge of an element, i.e. top-right in left-to-right languages.
    public static let topTrailing = DiagonalEdge(rawValue: 1 << 1)

    /// The bottom-leading edge of an element, i.e. bottom-left in left-to-right languages.
    public static let bottomLeading = DiagonalEdge(rawValue: 1 << 2)

    /// The bottom-trailing edge of an element, i.e. bottom-right in left-to-right languages.
    public static let bottomTrailing = DiagonalEdge(rawValue: 1 << 3)

    /// The top edge of an element, which is both top leading and top trailing.
    public static let top: DiagonalEdge = [.topLeading, .topTrailing]

    /// The bottom edge of an element, which is both bottom leading and bottom trailing.
    public static let bottom: DiagonalEdge = [.bottomLeading, .bottomTrailing]

    /// The leading edge of an element, which is both top leading and bottom leading.
    public static let leading: DiagonalEdge = [.topLeading, .bottomLeading]

    /// The trailing edge of an element, which is both top trailing and bottom trailing.
    public static let trailing: DiagonalEdge = [.topTrailing, .bottomTrailing]

    /// All edges of an element.
    public static let all: DiagonalEdge = [.leading, .trailing]
}
