//
// TestSiteWithErrorPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// A test site that shows an error page.
struct TestSiteWithErrorPage: Site {
    var name = "My Error Page Test Site"
    var titleSuffix = " - My Test Site"
    var url = URL(static: "https://www.example.com")
    var timeZone: TimeZone?
    var language: Language = .english

    var homePage = TestPage()
    var layout = EmptyLayout()

    var errorPage = TestErrorPage()

    var articlePages: [any ArticlePage] = [
        TestStory()
    ]

    var staticPages: [any StaticPage] = [
        TestPage()
    ]

    init() {}

    init(errorPage: ErrorPageType) {
        self.errorPage = errorPage
    }
}
