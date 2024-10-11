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
struct SubsiteBodyTests {
    /// A publishing context with sample values for subsite tests.
    let publishingSubsiteContext = try! PublishingContext(for: TestSubsite(), from: "Test Subsite")

    @Test("Simple Body Test")
    func test_body_simple() async throws {
        let element = Body(for: Page(title: "TITLE", description: "DESCRIPTION",
                                     url: URL("http://www.yoursite.com/subsite"),
                                     body: Text("TEXT")))
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == """
            <body><div class=\"col-sm-10 mx-auto\"><p>TEXT</p>\
            </div><script src=\"/subsite/js/bootstrap.bundle.min.js\"></script>\
            <script src=\"/subsite/js/syntax-highlighting.js\"></script></body>
            """)
    }

}
