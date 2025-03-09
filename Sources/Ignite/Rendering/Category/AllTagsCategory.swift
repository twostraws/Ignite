//
// AllTagsCategory.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// All tags applied to the articles of this site.
public struct AllTagsCategory: Category {
    /// The name of the category, which defaults to "All Tags".
    public var name = "All Tags"
    /// All of the articles that have a tag.
    public var articles: [Article]
}
