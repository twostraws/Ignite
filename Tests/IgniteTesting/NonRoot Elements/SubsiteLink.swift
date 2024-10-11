//
// SubsiteLink.swift                                
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for the `title` element.
@Suite("Subscribe Link Tests")
struct SubsiteLinkTests {
    /// A publishing context with sample values for subsite tests.
    let publishingSubsiteContext = try! PublishingContext(for: TestSubsite(), from: "Test Subsite")

    @Test("String Target Test")
    func test_string_target() async throws {
        let element = Link("Go Home", target: "/")
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == "<a href=\"/subsite/\">Go Home</a>")
    }
    @Test("Page Target Test")
    func test_page_target () async throws {
        let element = Link("This is a test", target: TestPage()).linkStyle(.button)
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == "<a href=\"/subsite/test-page\" class=\"btn btn-primary\">This is a test</a>")
    }
    @Test("Page Content Test")
    func test_page_content () async throws {
        let element = Link(target: TestPage(),
                           content: { "MORE "
            Text("CONTENT") })
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == "<a href=\"/subsite/test-page\">MORE <p>CONTENT</p></a>")
    }

}
