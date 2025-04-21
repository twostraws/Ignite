//
// FontStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func fontStyleModifier(
    _ style: Font.Style,
    content: any HTML
) -> any HTML {
    if content.isText {
        content.fontStyle(style)
    } else {
        content.class(style.sizeClass)
    }
}

@MainActor private func fontStyleModifier(
    _ style: Font.Style,
    content: any InlineElement
) -> any InlineElement {
    content.fontStyle(style)
}

public extension HTML {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some HTML {
        AnyHTML(fontStyleModifier(style, content: self))
    }
}

public extension InlineElement {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some InlineElement {
        AnyInlineElement(fontStyleModifier(style, content: self))
    }
}
