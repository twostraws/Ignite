//
// FixedSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that forces elements to size based on their content
struct FixedSizeModifier: HTMLModifier {
    /// Applies inline-block display to force content-based sizing
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with fixed sizing applied
    func body(content: some HTML) -> any HTML {
        content.addContainerStyle(.init(name: "display", value: "inline-block"))
    }
}

public extension HTML {
    /// Forces an element to be sized based on its content rather than expanding to fill its container.
    /// - Returns: A modified copy of the element with fixed sizing applied
    func fixedSize() -> some HTML {
        modifier(FixedSizeModifier())
    }
}
