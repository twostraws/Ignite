//
// InlineElementModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that modifies inline elements by wrapping or transforming their content.
@MainActor
public protocol InlineElementModifier {
    /// The type of inline element that this modifier produces.
    associatedtype Body: InlineElement

    /// A proxy that provides access to the content being modified.
    typealias Content = InlineModifiedContentProxy<Self>

    /// Creates the modified inline element.
    /// - Parameter content: The content to be modified.
    /// - Returns: The modified inline element.
    @InlineElementBuilder func body(content: Content) -> Body
}
