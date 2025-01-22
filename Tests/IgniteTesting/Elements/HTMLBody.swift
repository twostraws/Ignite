//
// HTMLBody.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `title` element.
@Suite("Body Tests")
@MainActor struct SubsiteBodyTests {
    init() {
        try! PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Simple Body Test")
    func simpleBody() async throws {
        let element = HTMLBody(
            for: Page(
                title: "TITLE", description: "DESCRIPTION",
                url: URL(static: "http://www.yoursite.com/subsite"),
                body: Text("TEXT")))
        let output = element.render()

        #expect(
            output == """
            <body class="container"><p>TEXT</p>\
            <script src="/js/bootstrap.bundle.min.js"></script>\
            <script src="/js/ignite-core.js"></script>\
            </body>
            """
        )
    }
}
