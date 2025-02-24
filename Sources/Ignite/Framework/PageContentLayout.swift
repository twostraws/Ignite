//
// Layoutable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows pages of any type to use a layout.
@MainActor
public protocol PageContentLayout: Sendable {
    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }
}

public extension PageContentLayout {
    // Default to `MissingLayout`, which will cause the main
    // site layout to be used instead.
    var parentLayout: any Layout {
        PublishingContext.shared.site.layout
    }
}
