//
// Hidden.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that controls element visibility
struct HiddenModifier: HTMLModifier {
    /// Whether the element should be hidden
    private let isHidden: Bool

    /// Creates a new hidden modifier with a boolean flag
    /// - Parameter isHidden: Whether to hide the element
    init(isHidden: Bool = true) {
        self.isHidden = isHidden
    }

    /// Applies visibility styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with visibility applied
    func body(content: some HTML) -> any HTML {
        return content.class(isHidden ? "d-none" : nil)
    }
}

extension HTML {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A modified copy of the element with visibility applied
    public func hidden(_ isHidden: Bool = true) -> some HTML {
        modifier(HiddenModifier(isHidden: isHidden))
    }
}
