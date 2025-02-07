//
// ContentLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public protocol ContentLayout: Sendable {
    /// The type of layout you want this page to use.
    associatedtype LayoutType: Layout

    /// The layout to apply around this page.
    var parentLayout: LayoutType { get }
}

public extension ContentLayout {
    // Default to `MissingLayout`, which will cause the main
    // site layout to be used instead.
    var parentLayout: MissingLayout { MissingLayout() }
}
