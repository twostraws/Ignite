//
// GridItemProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type whose subviews resolve to a collection of `GridItem`.
@MainActor
protocol GridItemProvider {
    /// Converts the row's content into an array of grid items.
    /// - Returns: An array of `GridItem` objects representing each piece of content.
    func gridItems() -> [GridItem]
}
