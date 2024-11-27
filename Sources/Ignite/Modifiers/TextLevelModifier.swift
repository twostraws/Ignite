//
// TextLevelModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies text level styling (headings, paragraphs, etc.) to HTML elements.
struct TextLevelModifier: HTMLModifier {
    /// The text level to apply to the content.
    var textLevel: Text.Level
    
    /// Applies the text level styling to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with text level styling applied
    func body(content: some HTML) -> any HTML {
        if content.body.isComposite {
            if textLevel == .lead {
                content.addContainerClass("lead")
                    .class("font-inherit")
            } else {
                Tag(textLevel.rawValue) {
                    content.class("font-inherit")
                }
            }
        } else if let text = content.body as? Text  {
            text.textLevel(textLevel)
        }
        content
    }
}

public extension HTML {
    /// Adjusts the heading level of this text.
    /// - Parameter textLevel: The new font level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ textLevel: Text.Level) -> some HTML {
        modifier(TextLevelModifier(textLevel: textLevel))
    }
}

public extension InlineHTML {
    /// Adjusts the heading level of this text.
    /// - Parameter textLevel: The new font level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ textLevel: Text.Level) -> some InlineHTML {
        modifier(TextLevelModifier(textLevel: textLevel))
    }
}
