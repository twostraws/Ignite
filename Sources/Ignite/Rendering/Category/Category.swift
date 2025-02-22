//
// Category.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The category by which articles on your site can be grouped.
public protocol Category: CustomStringConvertible, Sendable {
    /// The name of the category.
    var name: String { get }
    /// An array of content that belongs to this category.
    var content: [Content] { get }
}

public extension Category {
    var description: String {
        name
    }
}
