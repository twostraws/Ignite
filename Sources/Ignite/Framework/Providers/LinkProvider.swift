//
// LinkProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that has a `Link` as its root view.
@MainActor
protocol LinkProvider {
    /// The URL of the link at the root of the view hierarchy.
    var url: String { get }
}
