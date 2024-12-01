//
// LazyLoadable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that determines which elements can be loaded lazily.
public protocol LazyLoadable where Self: HTML {}

/// A modifier that enables lazy loading for HTML elements
struct LazyLoadModifier: HTMLModifier {
    /// Applies lazy loading to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with lazy loading enabled
    func body(content: some HTML) -> any HTML {
        content.customAttribute(name: "loading", value: "lazy")
    }
}

public extension HTML where Self: LazyLoadable {
    /// Enables lazy loading for this element.
    /// - Returns: A modified copy of the element with lazy loading enabled
    func lazy() -> some HTML {
        modifier(LazyLoadModifier())
    }
}
