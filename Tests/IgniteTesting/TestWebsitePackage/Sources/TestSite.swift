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
    var url = URL(static: "https://www.yoursite.com")
    var timeZone: TimeZone?

    var homePage = TestLayout()
    var layout = EmptyLayout()
    var builtInIconsEnabled: BootstrapOptions = .localBootstrap

    var feedConfiguration = FeedConfiguration(
        mode: .descriptionOnly,
        contentCount: 20,
        image: .init(url: "path/to/image.png", width: 100, height: 100)
    )
    
    var contentLayouts: [any ContentLayout] = [
        TestStory()
    ]

    init() {}

    init(timeZone: TimeZone) {
        self.timeZone = timeZone
    }
}

/// An example page used in tests.
struct TestLayout: StaticLayout {
    var title = "Home"

    var body: some HTML {
        Text("Hello, World!")
    }
}

/// A test publisher for ``TestSite``.
///
/// It helps to run `TestSite/publish` with a correct path of the file that triggered the build.
@MainActor
struct TestSitePublisher {
    
    let site = TestSite()
    
    func publish() async throws {
        try await site.publish()
    }
}

struct TestStory: ContentLayout {
    var body: some HTML {
        EmptyHTML()
    }
}
