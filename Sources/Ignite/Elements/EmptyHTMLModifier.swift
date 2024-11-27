//
// EmptyModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that makes no changes to HTML elements
/// Used as a default or fallback when no modifications are needed
public struct EmptyHTMLModifier: HTMLModifier {
    /// Applies no modifications to the provided HTML content
    /// - Parameter content: The HTML content to modify
    /// - Returns: The unmodified HTML content
    public func body(content: some HTML) -> any HTML {
        content
    }
}
