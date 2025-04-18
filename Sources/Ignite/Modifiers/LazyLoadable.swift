//
// LazyLoadable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that determines which elements can be loaded lazily.
public protocol LazyLoadable {}

public extension Element where Self: LazyLoadable {
    /// Enables lazy loading for this element.
    /// - Returns: A modified copy of the element with lazy loading enabled
    func lazy() -> some Element {
        self.customAttribute(name: "loading", value: "lazy")
    }
}
