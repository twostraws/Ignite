//
// NavigationItemConfigurable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows elements to be configured for placement in a navigation bar.
protocol NavigationItemConfigurable: BodyElement {
    /// Whether this element is configured as a navigation item.
    var isNavigationItem: Bool { get set }

    /// Returns a new instance of the element configured for use in a navigation bar.
    func configuredAsNavigationItem(_ isNavItem: Bool) -> Self
}

extension NavigationItemConfigurable {
    /// Configures this element to be placed inside a `NavigationBar`.
    /// - Returns: A new element instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem(_ isNavItem: Bool = true) -> Self {
        var copy = self
        copy.isNavigationItem = isNavItem
        return copy
    }
}
