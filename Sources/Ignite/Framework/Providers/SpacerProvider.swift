//
// SpacerProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that has a `Spacer` as its root view.
@MainActor
protocol SpacerProvider {
    /// The spacer at the root of the view hierarchy.
    var spacer: Spacer { get }
}
