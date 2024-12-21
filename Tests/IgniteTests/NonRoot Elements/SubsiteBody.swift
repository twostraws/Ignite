//
// SubsiteBody.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

/// Tests for the `title` element.
@MainActor final class SubsiteBodyTests: ElementTest {
    func test_body_simple() {
        let element = HTMLBody(for: Page(title: "TITLE", description: "DESCRIPTION",
                                         url: URL(static: "http://www.yoursite.com/subsite"),
                                         body: Text("TEXT")))
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(output, """
        <body><p>TEXT</p><script src="/subsite/js/bootstrap.bundle.min.js"></script><script src="/subsite/js/highlight.min.js"></script><script>hljs.highlightAll();</script><script src="/subsite/js/ignite-core.js"></script></body>
        """)
    }
}
