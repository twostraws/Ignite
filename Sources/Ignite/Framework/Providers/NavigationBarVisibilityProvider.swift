//
// NavigationBarVisibilityProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type whose root view has a configurable navigation bar visibility.
@MainActor
protocol NavigationBarVisibilityProvider {
    /// The navigation bar visibility of the root of the view hierarchy.
    var navigationBarVisibility: NavigationBarVisibility { get }
}
