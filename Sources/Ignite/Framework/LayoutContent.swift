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

    /// The page layout this content should use.
    var layout: any Layout { get }
}

public extension LayoutContent {
    // Default to `MissingLayout`, which will cause the main
    // site layout to be used instead.
    var layout: any Layout {
        PublishingContext.shared.site.layout
    }
}
