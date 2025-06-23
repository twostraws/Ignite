//
// Edge.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes edges on an element, e.g. top or leading, along
/// with groups of edges such as "horizontal" (leading *and* trailing).
public struct Edge: OptionSet, Sendable {
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

/// Both the margin() and padding() modifiers work identically apart from the exact
/// name of the CSS attribute they change, so their functionality is wrapped up here
/// to avoid code duplication. This should not be called directly.
extension Edge {
    /// Adjusts the edge value (margin or padding) for a view using an adaptive amount.
    /// - Parameters:
    ///   - prefix: Specifies what we are changing, e.g. "padding"
    ///   - edges: Which edges we are changing.
    ///   - amount: The value we are changing it to.
    /// - Returns: An array of class names for the edge adjustments.
    func classes(prefix: String, amount: Int) -> [String] {
        var classes = [String]()

        if self.contains(.all) {
            classes.append("\(prefix)-\(amount)")
            return classes
        }

        if self.contains(.horizontal) {
            classes.append("\(prefix)x-\(amount)")
        } else {
            if self.contains(.leading) {
                classes.append("\(prefix)s-\(amount)")
            }

            if self.contains(.trailing) {
                classes.append("\(prefix)e-\(amount)")
            }
        }

        if self.contains(.vertical) {
            classes.append("\(prefix)y-\(amount)")
        } else {
            if self.contains(.top) {
                classes.append("\(prefix)t-\(amount)")
            }

            if self.contains(.bottom) {
                classes.append("\(prefix)b-\(amount)")
            }
        }

        return classes
    }

    /// Generates inline CSS styles for edge adjustments (margin or padding) using custom length values.
    /// - Parameters:
    ///   - prefix: The CSS property prefix (e.g., "margin" or "padding").
    ///   - edges: The edges to apply the adjustment to.
    ///   - length: The custom length value as a string (e.g., "1rem", "10px").
    /// - Returns: An array of inline styles for the specified edges.
    func styles(prefix: String, length: String) -> [InlineStyle] {
        var styles = [InlineStyle]()

        if self.contains(.all) {
            styles.append(.init(prefix, value: length))
            return styles
        }

        if self.contains(.leading) {
            styles.append(.init("\(prefix)-left", value: length))
        }

        if self.contains(.trailing) {
            styles.append(.init("\(prefix)-right", value: length))
        }

        if self.contains(.top) {
            styles.append(.init("\(prefix)-top", value: length))
        }

        if self.contains(.bottom) {
            styles.append(.init("\(prefix)-bottom", value: length))
        }

        return styles
    }
}
