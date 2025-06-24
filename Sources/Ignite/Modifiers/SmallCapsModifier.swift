//
// SmallCaps.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Converts lowercase letters to small capitals while leaving uppercase letters unchanged.
    /// - Returns: A modified copy of the element with small caps applied
    func smallCaps() -> some HTML {
        self.style(.fontVariant, "small-caps")
    }
}

public extension InlineElement {
    /// Converts lowercase letters to small capitals while leaving uppercase letters unchanged.
    /// - Returns: A modified copy of the element with small caps applied
    func smallCaps() -> some InlineElement {
        self.style(.fontVariant, "small-caps")
    }
}
