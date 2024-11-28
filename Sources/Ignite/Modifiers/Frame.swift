//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies dimensional constraints to HTML elements
struct FrameModifier: HTMLModifier {
    /// The exact width to apply
    private let width: (any LengthUnit)?

    /// The minimum width to apply
    private let minWidth: (any LengthUnit)?

    /// The maximum width to apply
    private let maxWidth: (any LengthUnit)?

    /// The exact height to apply
    private let height: (any LengthUnit)?

    /// The minimum height to apply
    private let minHeight: (any LengthUnit)?

    /// The maximum height to apply
    private let maxHeight: (any LengthUnit)?

    /// The horizontal alignment within the frame
    private let alignment: HorizontalAlignment

    /// Creates a new frame modifier
    /// - Parameters:
    ///   - width: An exact width for this element
    ///   - minWidth: A minimum width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - height: An exact height for this element
    ///   - minHeight: A minimum height for this element
    ///   - maxHeight: A maximum height for this element
    ///   - alignment: How to align this element inside its frame
    init(
        width: (any LengthUnit)? = nil,
        minWidth: (any LengthUnit)? = nil,
        maxWidth: (any LengthUnit)? = nil,
        height: (any LengthUnit)? = nil,
        minHeight: (any LengthUnit)? = nil,
        maxHeight: (any LengthUnit)? = nil,
        alignment: HorizontalAlignment = .center
    ) {
        self.width = width
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.height = height
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
    }

    /// Applies frame constraints to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with frame constraints applied
    func body(content: some HTML) -> any HTML {
        var modified = content

        if let width {
            modified = modified.style("width: \(width.stringValue)")
        }

        if let minWidth {
            modified = modified.style("min-width: \(minWidth.stringValue)")
        }

        if let maxWidth {
            modified = modified.style("max-width: \(maxWidth.stringValue)")
        }

        if let height {
            modified = modified.style("height: \(height.stringValue)")
        }

        if let minHeight {
            modified = modified.style("min-height: \(minHeight.stringValue)")
        }

        if let maxHeight {
            modified = modified.style("max-height: \(maxHeight.stringValue)")
        }

        if alignment == .center {
            modified = modified.class("mx-auto")
        } else if alignment == .leading {
            modified = modified.style("margin-right: auto")
        } else {
            modified = modified.style("margin-left: auto")
        }

        return modified
    }
}

public extension HTML {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges. Sizes can be specified using any type conforming
    /// to the Unit protocol (String, Int, Double).
    /// - Parameters:
    ///   - width: An exact width for this element
    ///   - minWidth: A minimum width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - height: An exact height for this element
    ///   - minHeight: A minimum height for this element
    ///   - maxHeight: A maximum height for this element
    ///   - alignment: How to align this element inside its frame
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: (any LengthUnit)? = nil,
        minWidth: (any LengthUnit)? = nil,
        maxWidth: (any LengthUnit)? = nil,
        height: (any LengthUnit)? = nil,
        minHeight: (any LengthUnit)? = nil,
        maxHeight: (any LengthUnit)? = nil,
        alignment: HorizontalAlignment = .center
    ) -> some HTML {
        modifier(FrameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment
        ))
    }
}
