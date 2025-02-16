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
@MainActor
class BodyTests: IgniteTestSuite {
    @Test("Body Test")
    func body() async throws {
        let element = HTMLBody(
            for: Page(
                title: "TITLE", description: "DESCRIPTION",
                url: site.url,
                body: Text("TEXT")))
        let output = element.render()
        let path = site.url.decodedPath

        #expect(output == """
        <body class="container"><p>TEXT</p>\
        <script src="\(path)/js/bootstrap.bundle.min.js"></script>\
        <script src="\(path)/js/ignite-core.js"></script>\
        </body>
        """)
    }
}
