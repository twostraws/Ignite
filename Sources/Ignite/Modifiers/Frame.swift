//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension BlockElement {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges. Sizes are specified in units
    /// of your choosing, e.g. "50%", "2cm", or "50vw".
    /// - Parameters:
    ///   - width: An exact width for this element.
    ///   - minWidth: A minimum width for this element.
    ///   - maxWidth: A maximum width for this element.
    ///   - height: An exact height for this element.
    ///   - minHeight: A minimum height for this element.
    ///   - maxHeight: A maximum height for this element.
    /// - Returns: A copy of the current element with the new frame applied.
    public func frame(
        width: String? = nil,
        minWidth: String? = nil,
        maxWidth: String? = nil,
        height: String? = nil,
        minHeight: String? = nil,
        maxHeight: String? = nil
    ) -> Self {
        var copy = self

        if let width {
            copy = copy.style("width: \(width)")
        }

        if let minWidth {
            copy = copy.style("min-width: \(minWidth)")
        }

        if let maxWidth {
            copy = copy.style("max-width: \(maxWidth)")
        }

        if let height {
            copy = copy.style("height: \(height)")
        }

        if let minHeight {
            copy = copy.style("min-height: \(minHeight)")
        }

        if let maxHeight {
            copy = copy.style("max-height: \(maxHeight)")
        }

        return copy
    }

    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges. Sizes are specified as pixels.
    /// - Parameters:
    ///   - width: An exact width for this element.
    ///   - minWidth: A minimum width for this element.
    ///   - maxWidth: A maximum width for this element.
    ///   - height: An exact height for this element.
    ///   - minHeight: A minimum height for this element.
    ///   - maxHeight: A maximum height for this element.
    /// - Returns: A copy of the current element with the new frame applied.
    public func frame(
        width: Int? = nil,
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        height: Int? = nil,
        minHeight: Int? = nil,
        maxHeight: Int? = nil
    ) -> Self {
        self.frame(
            width: width.map { "\($0)px" },
            minWidth: minWidth.map { "\($0)px" },
            maxWidth: maxWidth.map { "\($0)px" },
            height: height.map { "\($0)px" },
            minHeight: minHeight.map { "\($0)px" },
            maxHeight: maxHeight.map { "\($0)px" }
        )
    }
}
