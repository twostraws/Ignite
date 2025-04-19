//
// EdgeAdjust.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Both the margin() and padding() modifiers work identically apart from the exact
/// name of the CSS attribute they change, so their functionality is wrapped up here
/// to avoid code duplication. This should not be called directly.
extension BodyElement {
    /// Adjusts the edge value (margin or padding) for a view using an adaptive amount.
    /// - Parameters:
    ///   - prefix: Specifies what we are changing, e.g. "padding"
    ///   - edges: Which edges we are changing.
    ///   - amount: The value we are changing it to.
    /// - Returns: An array of class names for the edge adjustments.
    func edgeAdjustedClasses(prefix: String, _ edges: Edge = .all, _ amount: Int) -> [String] {
        var classes = [String]()

        if edges.contains(.all) {
            classes.append("\(prefix)-\(amount)")
            return classes
        }

        if edges.contains(.horizontal) {
            classes.append("\(prefix)x-\(amount)")
        } else {
            if edges.contains(.leading) {
                classes.append("\(prefix)s-\(amount)")
            }

            if edges.contains(.trailing) {
                classes.append("\(prefix)e-\(amount)")
            }
        }

        if edges.contains(.vertical) {
            classes.append("\(prefix)y-\(amount)")
        } else {
            if edges.contains(.top) {
                classes.append("\(prefix)t-\(amount)")
            }

            if edges.contains(.bottom) {
                classes.append("\(prefix)b-\(amount)")
            }
        }

        return classes
    }
}

extension Stylable {
    /// Adjusts the edge value (margin or padding) for a view.
    /// - Parameters:
    ///   - prefix: Specifies what we are changing, e.g. "padding"
    ///   - edges: Which edges we are changing.
    ///   - length: The value we are changing it to.
    /// - Returns: An array of InlineStyle with the edge adjustments.
    func edgeAdjustedStyles(prefix: String, _ edges: Edge = .all, _ length: String = "20px") -> [InlineStyle] {
        var styles = [InlineStyle]()

        if edges.contains(.all) {
            styles.append(.init(prefix, value: length))
            return styles
        }

        if edges.contains(.leading) {
            styles.append(.init("\(prefix)-left", value: length))
        }

        if edges.contains(.trailing) {
            styles.append(.init("\(prefix)-right", value: length))
        }

        if edges.contains(.top) {
            styles.append(.init("\(prefix)-top", value: length))
        }

        if edges.contains(.bottom) {
            styles.append(.init("\(prefix)-bottom", value: length))
        }

        return styles
    }
}
