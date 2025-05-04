//
// TestSite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example site used in tests.
struct TestSite: Site {
    var name = "My Test Site"
    var titleSuffix = " - My Test Site"
    var url = URL(static: "https://www.example.com")
    var timeZone: TimeZone?
    var language: Language = .english

    var homePage = TestPage()
    var layout = EmptyLayout()
    var builtInIconsEnabled: BootstrapOptions = .localBootstrap

    var feedConfiguration = FeedConfiguration(
        mode: .descriptionOnly,
        contentCount: 20,
        image: .init(url: "path/to/image.png", width: 100, height: 100)
    )

    var articlePages: [any ArticlePage] = [
        TestStory()
    ]

    init() {}

    init(timeZone: TimeZone) {
        self.timeZone = timeZone
    }
}
