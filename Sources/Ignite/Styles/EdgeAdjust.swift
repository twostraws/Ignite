//
// EdgeAdjust.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Both the margin() and padding() modifiers work identically apart from the exact
/// name of the CSS attribute they change, so their functionality is wrapped up here
/// to avoid code duplication. This should not be called directly.
extension Modifiable {
    /// Adjusts the edge value (margin or padding) for a view.
    /// - Parameters:
    ///   - prefix: Specifies what we are changing, e.g. "padding"
    ///   - edges: Which edges we are changing.
    ///   - length: The value we are changing it to.
    /// - Returns: A copy of the current element with the updated edge adjustment.
    func edgeAdjust(prefix: String, _ edges: Edge = .all, _ length: String = "20px") -> Self {
        if edges.contains(.all) {
            return self.style(.init(name: prefix, value: length))
        }

        var copy = self

        if edges.contains(.leading) {
            copy.style(.init(name: "\(prefix)-left", value: length))
        }

        if edges.contains(.trailing) {
            copy.style(.init(name: "\(prefix)-right", value: length))
        }

        if edges.contains(.top) {
            copy.style(.init(name: "\(prefix)-top", value: length))
        }

        if edges.contains(.bottom) {
            copy.style(.init(name: "\(prefix)-bottom", value: length))
        }

        return copy
    }
}

extension HTML {
    /// Adjusts the edge value (margin or padding) for a view using an adaptive amount.
    /// - Parameters:
    ///   - prefix: Specifies what we are changing, e.g. "padding"
    ///   - edges: Which edges we are changing.
    ///   - amount: The value we are changing it to.
    /// - Returns: A copy of the current element with the updated edge adjustment.
    func edgeAdjust(prefix: String, _ edges: Edge = .all, _ amount: SpacingAmount) -> Self {
        if edges.contains(.all) {
            return self.class("\(prefix)-\(amount.rawValue)")
        }

        var copy = self

        if edges.contains(.horizontal) {
            copy.class("\(prefix)x-\(amount.rawValue)")
        } else {
            if edges.contains(.leading) {
                copy.class("\(prefix)s-\(amount.rawValue)")
            }

            if edges.contains(.trailing) {
                copy.class("\(prefix)e-\(amount.rawValue)")
            }
        }

        if edges.contains(.vertical) {
            copy.class("\(prefix)y-\(amount.rawValue)")
        } else {
            if edges.contains(.top) {
                copy.class("\(prefix)t-\(amount.rawValue)")
            }

            if edges.contains(.bottom) {
                copy.class("\(prefix)b-\(amount.rawValue)")
            }
        }

        return copy
    }
}
