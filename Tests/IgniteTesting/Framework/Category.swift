//
//  Category.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Category` protocol and its concrete types.
@Suite("Category Tests")
@MainActor
struct CategoryTests {
    // MARK: - EmptyCategory

    @Test("EmptyCategory name is empty string")
    func emptyCategoryName() async throws {
        let category = EmptyCategory()
        #expect(category.name == "")
    }

    @Test("EmptyCategory articles is empty array")
    func emptyCategoryArticles() async throws {
        let category = EmptyCategory()
        #expect(category.articles.isEmpty)
    }

    // MARK: - TagCategory

    @Test("TagCategory stores name")
    func tagCategoryStoresName() async throws {
        let category = TagCategory(name: "Swift", articles: [])
        #expect(category.name == "Swift")
    }

    @Test("TagCategory stores articles")
    func tagCategoryStoresArticles() async throws {
        let articles = [Article(), Article()]
        let category = TagCategory(name: "Swift", articles: articles)
        #expect(category.articles.count == 2)
    }

    // MARK: - AllTagsCategory

    @Test("AllTagsCategory default name is All Tags")
    func allTagsCategoryDefaultName() async throws {
        let category = AllTagsCategory(articles: [])
        #expect(category.name == "All Tags")
    }

    @Test("AllTagsCategory stores articles")
    func allTagsCategoryStoresArticles() async throws {
        let articles = [Article(), Article(), Article()]
        let category = AllTagsCategory(articles: articles)
        #expect(category.articles.count == 3)
    }

    // MARK: - Category protocol

    @Test("Category description returns name")
    func categoryDescriptionReturnsName() async throws {
        let category = TagCategory(name: "iOS", articles: [])
        #expect(category.description == "iOS")
    }

    @Test("EmptyCategory description is empty string")
    func emptyCategoryDescriptionIsEmpty() async throws {
        let category = EmptyCategory()
        #expect(category.description == "")
    }
}
