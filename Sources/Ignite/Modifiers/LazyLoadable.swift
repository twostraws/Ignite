//
// LazyLoadable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that determines which elements can be loaded lazily.
public protocol LazyLoadable where Self: PageElement {
    /// Enables lazy loading for this element.
    /// - Returns: A copy of the current element with lazy loading enabled.
    func lazy() -> Self
}

extension LazyLoadable {
    /// Enables lazy loading for this element.
    /// - Returns: A copy of the current element with lazy loading enabled.
    public func lazy() -> Self {
        self.addCustomAttribute(name: "loading", value: "lazy")
    }
}
