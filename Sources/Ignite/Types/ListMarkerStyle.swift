//
// ListMarkerStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls whether this list contains items in a specific order or not.
public enum ListMarkerStyle: Sendable {
    /// This list contains items that are ordered, which normally means
    /// they are rendered with numbers such as 1, 2, 3.
    case ordered(OrderedListMarkerStyle)

    /// This list contains items that are unordered, which normally means
    /// they are rendered with bullet points.
    case unordered(UnorderedListMarkerStyle)

    /// This list is unordered, with a custom symbol for bullet points.
    /// - Note: Although you can technically pass more than one
    /// emoji here, you might find the alignment gets strange.
    case custom(String)

    /// A convenience for creating ordered lists with automatic numbering.
    public static var ordered: Self { .ordered(.automatic) }

    /// A convenience for creating unordered lists with automatic bullet points.
    public static var unordered: Self { .unordered(.automatic) }
}
