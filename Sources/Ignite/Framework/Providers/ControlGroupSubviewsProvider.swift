//
// ControlGroupSubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An `ControlGroupElement` that has `PackHTML` as its root view.
@MainActor
protocol ControlGroupSubviewsProvider {
    /// The collection of subviews contained within this provider.
    var subviews: ControlGroupSubviewsCollection { get }
}
