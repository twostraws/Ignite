//
// SmallCaps.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies small caps styling to text elements.
struct SmallCapsModifier: HTMLModifier {
    /// Applies small caps styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with small caps applied
    func body(content: some HTML) -> any HTML {
        content.style(.fontVariant, "small-caps")
    }
}

public extension HTML {
    /// Converts lowercase letters to small capitals while leaving uppercase letters unchanged.
    /// - Returns: A modified copy of the element with small caps applied
    func smallCaps() -> some HTML {
        modifier(SmallCapsModifier())
    }
}

public extension InlineElement {
    /// Converts lowercase letters to small capitals while leaving uppercase letters unchanged.
    /// - Returns: A modified copy of the element with small caps applied
    func smallCaps() -> some InlineElement {
        modifier(SmallCapsModifier())
    }
}

public extension BlockHTML {
    /// Converts lowercase letters to small capitals while leaving uppercase letters unchanged.
    /// - Returns: A modified copy of the element with small caps applied
    func smallCaps() -> some BlockHTML {
        modifier(SmallCapsModifier())
    }
}
