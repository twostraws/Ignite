//
// SubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An `HTML` element that has `PackHTML` as its root view.
@MainActor
protocol SubviewsProvider {
    /// The collection of subviews contained within this provider.
    var subviews: SubviewsCollection { get }
}
