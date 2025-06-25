//
// CarouselSubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An `CarouselElement` that has `PackHTML` as its root view.
@MainActor
protocol CarouselSubviewsProvider {
    /// The collection of subviews contained within this provider.
    var subviews: CarouselSubviewsCollection { get }
}
