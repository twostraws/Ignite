//
// FontStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some HTML {
        AnyHTML(fontStyleModifier(style: style))
    }
}

public extension InlineElement {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some InlineElement {
        AnyHTML(fontStyleModifier(style: style))
    }
}

private extension HTML {
    func fontStyleModifier(style: Font.Style) -> any HTML {
        if self.isText {
            self.fontStyle(style)
        } else {
            self.class(style.fontSizeClass)
        }
    }
}
