//
// Layoutable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows pages of any type to use a layout.
@MainActor
public protocol Layoutable: Sendable {
    /// The type of layout you want this page to use.
    associatedtype LayoutType: Layout

    /// The layout to apply around this page.
    var parentLayout: LayoutType { get }
}

public extension Layoutable {
    // Default to `MissingLayout`, which will cause the main
    // site layout to be used instead.
    var parentLayout: MissingLayout { MissingLayout() }
}
