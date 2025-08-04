//
// HTMLModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that modifies HTML content.
@MainActor
public protocol HTMLModifier {
    /// The type of HTML content this modifier produces.
    associatedtype Body: HTML

    /// A proxy that provides access to the content being modified.
    typealias Content = ModifiedContentProxy<Self>

    /// Returns the modified HTML content.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified HTML content.
    @HTMLBuilder func body(content: Content) -> Body
}
