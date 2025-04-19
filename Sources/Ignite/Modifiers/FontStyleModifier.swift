//
// FontStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func fontStyleModifier(
    _ style: Font.Style,
    content: any Element
) -> any Element {
    if content.isText {
        content.fontStyle(style)
    } else {
        content.class(style.fontSizeClass)
    }
}

@MainActor private func fontStyleModifier(
    _ style: Font.Style,
    content: any InlineElement
) -> any InlineElement {
    content.fontStyle(style)
}

public extension Element {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some Element {
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
