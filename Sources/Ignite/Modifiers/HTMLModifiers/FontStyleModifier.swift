//
// FontStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies font styling to HTML content.
private struct FontStyleModifier: HTMLModifier {
    /// The font style to apply.
    var style: FontStyle

    /// Creates the modified HTML content with the specified font style.
    /// - Parameter content: The content to modify.
    /// - Returns: HTML content with the applied font style.
    func body(content: Content) -> some HTML {
        var modified = content
        modified.attributes.append(classes: style.sizeClass)
        return modified
    }
}

public extension HTML {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some HTML {
        modifier(FontStyleModifier(style: style))
    }
}
