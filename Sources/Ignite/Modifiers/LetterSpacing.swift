//
// LetterSpacingModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that controls letter spacing (tracking) for text elements.
struct LetterSpacingModifier: HTMLModifier {
    /// The letter spacing value to apply
    private let spacing: LengthUnit

    /// Creates a new letter spacing modifier
    /// - Parameter spacing: The amount of spacing between letters
    init(_ spacing: LengthUnit) {
        self.spacing = spacing
    }

    /// Applies letter spacing to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with letter spacing applied
    func body(content: some HTML) -> any HTML {
        content.style(.letterSpacing, spacing.stringValue)
    }
}

public extension HTML {
    /// Adjusts the spacing between letters in text.
    /// - Parameter spacing: The amount of spacing to apply between letters
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ spacing: LengthUnit) -> some HTML {
        modifier(LetterSpacingModifier(spacing))
    }

    /// Adjusts the spacing between letters in text using pixels.
    /// - Parameter pixels: The amount of spacing to apply between letters in pixels
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ pixels: Int) -> some HTML {
        letterSpacing(.px(pixels))
    }
}

public extension InlineElement {
    /// Adjusts the spacing between letters in inline text.
    /// - Parameter spacing: The amount of spacing to apply between letters
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ spacing: LengthUnit) -> some InlineElement {
        modifier(LetterSpacingModifier(spacing))
    }

    /// Adjusts the spacing between letters in inline text using pixels.
    /// - Parameter pixels: The amount of spacing to apply between letters in pixels
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ pixels: Int) -> some InlineElement {
        letterSpacing(.px(pixels))
    }
}

public extension BlockHTML {
    /// Adjusts the spacing between letters in block-level text.
    /// - Parameter spacing: The amount of spacing to apply between letters
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ spacing: LengthUnit) -> some BlockHTML {
        modifier(LetterSpacingModifier(spacing))
    }

    /// Adjusts the spacing between letters in block-level text using pixels.
    /// - Parameter pixels: The amount of spacing to apply between letters in pixels
    /// - Returns: A modified copy of the element with letter spacing applied
    func letterSpacing(_ pixels: Int) -> some BlockHTML {
        letterSpacing(.px(pixels))
    }
}
