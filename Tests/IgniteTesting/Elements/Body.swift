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
@MainActor class BodyTests: IgniteTestSuite {
    static let sites: [any Site] = [TestSite(), TestSubsite()]

    @Test("Simple Body Test", arguments: await Self.sites)
    func simpleBody(for site: any Site) async throws {
        publishingContext.environment.page = Page(
            title: "TITLE", description: "DESCRIPTION",
            url: site.url,
            body: Text("TEXT"))

        let element = Body()
        let output = element.render()
        let path = publishingContext.path(for: URL(string: "/js")!)

        #expect(output == """
        <body class="container"><p>TEXT</p>\
        <script src="\(path)/bootstrap.bundle.min.js"></script>\
        <script src="\(path)/ignite-core.js"></script>\
        </body>
        """)
    }
}
