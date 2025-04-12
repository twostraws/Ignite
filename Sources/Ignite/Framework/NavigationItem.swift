//
// NavigationItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into navigation bars.
public protocol NavigationItem: HTML {
    func renderInNavigationBar() -> String
}

public extension NavigationItem {
    func renderInNavigationBar() -> String {
        render()
    }
}
