//
// Clipped.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that clips content to its bounds using overflow: hidden
struct ClippedModifier: HTMLModifier {
    /// Applies overflow:hidden to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with clipping applied
    func body(content: some HTML) -> any HTML {
        content.style("overflow: hidden")
    }
}

public extension HTML {
    /// Applies CSS overflow:hidden to clip the element's content to its bounds.
    /// - Returns: A modified copy of the element with clipping applied
    func clipped() -> some HTML {
        modifier(ClippedModifier())
    }
}
