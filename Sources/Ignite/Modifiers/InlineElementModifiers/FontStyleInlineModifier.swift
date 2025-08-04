//
// FontStyleInlineModifier.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct FontStyleInlineModifier: InlineElementModifier {
    var style: FontStyle
    func body(content: Content) -> some InlineElement {
        content.class(style.sizeClass)
    }
}

public extension InlineElement {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some InlineElement {
        modifier(FontStyleInlineModifier(style: style))
    }
}
