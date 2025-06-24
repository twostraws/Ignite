//
// LineSpacingInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies line spacing to inline elements.
private struct LineSpacingInlineModifier: InlineElementModifier {
    /// The line spacing configuration to apply.
    var spacing: Amount<Double, LineSpacing>

    /// Applies the line spacing configuration to the provided content.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified inline element with line spacing applied.
    func body(content: Content) -> some InlineElement {
        var modified = content
        switch spacing {
        case .exact(let spacing):
            modified.attributes.append(styles: .init(.lineHeight, value: spacing.formatted(.nonLocalizedDecimal)))
        case .semantic(let spacing):
            modified.attributes.append(classes: "lh-\(spacing.rawValue)")
        default: break
        }
        return modified
    }
}

public extension InlineElement {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified InlineElement element.
    func lineSpacing(_ spacing: Double) -> some InlineElement {
        modifier(LineSpacingInlineModifier(spacing: .exact(spacing)))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified InlineElement element.
    func lineSpacing(_ spacing: LineSpacing) -> some InlineElement {
        modifier(LineSpacingInlineModifier(spacing: .semantic(spacing)))
    }
}
