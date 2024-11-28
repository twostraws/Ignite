//
// Opacity.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies opacity styling to HTML elements
struct OpacityModifier: HTMLModifier {
    /// The opacity value between 0% (transparent) and 100% (opaque)
    private let percentage: Percentage?

    /// The opacity value between 0 (transparent) and 1.0 (opaque)
    private let doubleValue: Double?

    /// Creates a new opacity modifier
    /// - Parameter value: The opacity value to apply (0-100%)
    init(value: Percentage) {
        self.percentage = value
        self.doubleValue = nil
    }

    /// Creates a new opacity modifier
    /// - Parameter value: The opacity value to apply (0-1.0)
    init(value: Double) {
        self.doubleValue = value
        self.percentage = nil
    }

    /// Applies opacity styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with opacity applied
    func body(content: some HTML) -> any HTML {
        if let percentage, percentage != 100% {
            content.style("opacity: \(percentage.value)")
        } else if let doubleValue, doubleValue != 1 {
            content.style("opacity: \(doubleValue.formatted())")
        }
        content
    }
}

extension HTML {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    public func opacity(_ value: Percentage) -> some HTML {
        modifier(OpacityModifier(value: value))
    }

    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1.0 (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    public func opacity(_ value: Double) -> some HTML {
        modifier(OpacityModifier(value: value))
    }
}
