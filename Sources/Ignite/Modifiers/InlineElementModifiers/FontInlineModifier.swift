//
// FontInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies font styling to inline elements.
private struct FontInlineModifier: InlineElementModifier {
    /// The font configuration to apply.
    var font: Font

    func body(content: Content) -> some InlineElement {
        FontModifier.register(font: font)
        let attributes = FontModifier.attributes(for: font, includeStyle: true)
        var modified = content
        modified.attributes.merge(attributes)
        return modified
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        return modifier(FontInlineModifier(font: font))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some InlineElement {
        return modifier(FontInlineModifier(font: font.font))
    }
}
