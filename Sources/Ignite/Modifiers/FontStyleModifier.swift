//
// TextLevelModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies text level styling (headings, paragraphs, etc.) to HTML elements.
struct FontStyleModifier: HTMLModifier {
    /// The text level to apply to the content.
    var style: Font.Style

    /// Applies the text level styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with text level styling applied
    func body(content: some HTML) -> any HTML {

        var isText = content is Text ||
        (content as? ModifiedHTML)?.content is Text ||
        content.body is Text

        if isText {
            content
                .fontStyle(style)
        } else {
            content
                .containerClass(style.fontSizeClass)
                .class("font-inherit")
        }
    }
}

public extension HTML {
    /// Adjusts the heading level of this text.
    /// - Parameter textLevel: The new font level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some HTML {
        modifier(FontStyleModifier(style: style))
    }
}

public extension InlineHTML {
    /// Adjusts the heading level of this text.
    /// - Parameter textLevel: The new font level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some InlineHTML {
        modifier(FontStyleModifier(style: style))
    }
}
