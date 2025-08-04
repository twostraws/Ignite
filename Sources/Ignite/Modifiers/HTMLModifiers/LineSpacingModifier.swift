//
// LineSpacingModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies line spacing to HTML content.
private struct LineSpacingModifier: HTMLModifier {
    /// The line spacing amount to apply.
    var spacing: LineSpacingAmount

    /// Creates the modified HTML content with the specified line spacing.
    /// - Parameter content: The HTML content to modify.
    /// - Returns: HTML content with applied line spacing.
    func body(content: Content) -> some HTML {
        LineSpacedHTML(content, spacing: spacing)
    }
}

public extension HTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: Double) -> some HTML {
        modifier(LineSpacingModifier(spacing: .exact(spacing)))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: LineSpacing) -> some HTML {
        modifier(LineSpacingModifier(spacing: .semantic(spacing)))
    }
}

public extension StyledHTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter height: The line height multiplier to use
    /// - Returns: The modified HTML element
    func lineSpacing(_ height: Double) -> Self {
        self.style(.lineHeight, String(height))
    }
}
