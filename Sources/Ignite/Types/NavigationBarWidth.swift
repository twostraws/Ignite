//
// NavigationBarWidth.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The new number of columns to use.
public enum NavigationBarWidth: Sendable {
    /// Viewport sets column width
    case viewport
    /// Specific count sets column width
    case count(Int)
}
