//
// SubsiteBody.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `title` element.
@Suite("Subsite Body Tests")
@MainActor struct SubsiteBodyTests {
    let publishingContext = ElementTest.publishingSubsiteContext

    @Test("Simple Body Test")
    func simpleBody() async throws {
        let element = HTMLBody(
            for: Page(
                title: "TITLE", description: "DESCRIPTION",
                url: URL(static: "http://www.yoursite.com/subsite"),
                body: Text("TEXT")))
        let output = element.render(context: publishingContext)

        #expect(
            output == """
            <body class="container"><p>TEXT</p>\
            <script src="/subsite/js/bootstrap.bundle.min.js"></script>\
            <script src="/subsite/js/ignite-core.js"></script>\
            </body>
            """
        )
    }
}
