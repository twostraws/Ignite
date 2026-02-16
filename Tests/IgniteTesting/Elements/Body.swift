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
    @Test("Simple Body Test")
    func simpleBody() async throws {
        let element = Body()
        let output = element.markupString()
        let path = publishingContext.path(for: URL(string: "/js")!)

        #expect(output == """
        <body class="container">\
        <script src="\(path)/bootstrap.bundle.min.js"></script>\
        <script src="\(path)/ignite-core.js"></script>\
        </body>
        """)
    }

    @Test("Body with content renders content inside body tags")
    func bodyWithContent() async throws {
        let element = Body { Text("Hello") }
        let output = element.markupString()
        #expect(output.contains("<body"))
        #expect(output.contains("Hello"))
        #expect(output.contains("</body>"))
    }

    @Test("Body without container omits container class")
    func bodyIgnorePageGutters() async throws {
        let element = Body().ignorePageGutters()
        let output = element.markupString()
        #expect(!output.contains("container"))
    }

    @Test("Body with data attribute renders data attribute")
    func bodyDataAttribute() async throws {
        let element = Body().data("theme", "dark")
        let output = element.markupString()
        #expect(output.contains("data-theme=\"dark\""))
    }
}
