//
// TagCategory.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// A single tag applied to an article.
public struct TagCategory: Category {
    /// The name of the tag.
    public var name: String
    /// An array of content that has this tag.
    public var articles: [Article]
}
