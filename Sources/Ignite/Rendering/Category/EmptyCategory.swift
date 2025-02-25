//
// EmptyCategory.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents the absense of a category.
struct EmptyCategory: Category {
    var name: String { "" }
    var articles: [Article] { [] }
}
