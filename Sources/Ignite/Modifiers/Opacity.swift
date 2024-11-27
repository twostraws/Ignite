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
    private let value: Percentage
    
    /// Creates a new opacity modifier
    /// - Parameter value: The opacity value to apply (0-100%)
    init(value: Percentage) {
        self.value = value
    }
    
    /// Applies opacity styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with opacity applied
    func body(content: some HTML) -> any HTML {
        if value != 100% {
            return content.style("opacity: \(value.value)")
        }
        return content
    }
}

public extension HTML {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Percentage) -> some HTML {
        modifier(OpacityModifier(value: value))
    }
}
