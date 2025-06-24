//
// NavigationSubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An `NavigationElement` that has `PackHTML` as its root view.
@MainActor
protocol NavigationSubviewsProvider {
    /// The collection of subviews contained within this provider.
    var children: NavigationSubviewsCollection { get }
}
