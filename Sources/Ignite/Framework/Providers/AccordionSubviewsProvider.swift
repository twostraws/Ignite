//
// AccordionSubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An `AccordionElement` that has `PackHTML` as its root view.
@MainActor
protocol AccordionSubviewsProvider {
    /// The collection of subviews contained within this provider.
    var subviews: AccordionSubviewsCollection { get }
}
