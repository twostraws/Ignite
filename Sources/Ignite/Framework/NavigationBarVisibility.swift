//
// NavigationBarVisibility.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Determines how a navigation item responds to different viewport sizes.
public enum NavigationBarVisibility {
    /// Automatically collapses the item into a menu at small screen sizes.
    case automatic
    /// Ensures visibility in the navigation bar at all viewport sizes.
    case always
}
