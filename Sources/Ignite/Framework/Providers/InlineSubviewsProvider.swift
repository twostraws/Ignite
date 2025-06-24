//
// InlineSubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An `InlineElement` that has `PackHTML` as its root view.
@MainActor
protocol InlineSubviewsProvider {
    /// The collection of subviews contained within this provider.
    var subviews: InlineSubviewsCollection { get }
}
