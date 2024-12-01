//
// TextDecoration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Property sets the appearance of decorative lines on text.
public enum TextDecoration: String {
    case none
    case through = "line-through"
    case underline
}

/// A modifier that applies text decoration styling to HTML elements.
struct TextDecorationModifier: HTMLModifier {
    /// The type of text decoration to apply (underline, line-through, etc.)
    var style: TextDecoration
    
    /// Applies text decoration styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with text decoration applied
    func body(content: some HTML) -> any HTML {
        content.style("text-decoration: \(style)")
    }
}

public extension HTML {
    /// Applies a text decoration style to the current element.
    /// - Parameter style: The style to apply, specified as a `TextDecoration` case.
    /// - Returns: The current element with the updated text decoration style applied.
    func textDecoration(_ style: TextDecoration) -> some HTML {
        modifier(TextDecorationModifier(style: style))
    }
}
