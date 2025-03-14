//
// Layoutable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows pages of any type to use a layout.
@MainActor
public protocol LayoutContent: Sendable {
    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }

    /// The type of layout you want this page to use.
    associatedtype LayoutType: Layout

    /// The page layout this content should use.
    var layout: LayoutType { get }
}

public extension LayoutContent {
    /// Defaults to the main layout defined in `Site`.
    var layout: DefaultLayout {
        DefaultLayout()
    }
}
