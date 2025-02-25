//
// LetterSpacingModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the spacing between letters in text.
    /// - Parameter spacing: The amount of spacing to apply between letters
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ spacing: LengthUnit) -> some HTML {
        self.style(.letterSpacing, spacing.stringValue)
    }

    /// Adjusts the spacing between letters in text using pixels.
    /// - Parameter pixels: The amount of spacing to apply between letters in pixels
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ pixels: Int) -> some HTML {
        self.style(.letterSpacing, LengthUnit.px(pixels).stringValue)
    }
}

public extension InlineElement {
    /// Adjusts the spacing between letters in inline text.
    /// - Parameter spacing: The amount of spacing to apply between letters
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ spacing: LengthUnit) -> some InlineElement {
        self.style(.letterSpacing, spacing.stringValue)
    }

    /// Adjusts the spacing between letters in inline text using pixels.
    /// - Parameter pixels: The amount of spacing to apply between letters in pixels
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ pixels: Int) -> some InlineElement {
        self.style(.letterSpacing, LengthUnit.px(pixels).stringValue)
    }
}
