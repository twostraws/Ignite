//
// SubsiteScript.swift                              
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for the `title` element.
@Suite("Subsite Script Tests")
struct SubsiteScriptTests {
    /// A publishing context with sample values for subsite tests.
    let publishingSubsiteContext = try! PublishingContext(for: TestSubsite(), from: "Test Subsite")

    @Test("Empty Element")
    func test_empty() async throws {
        let element = Script(file: "/js/bootstrap.bundle.min.js").render(context: publishingSubsiteContext)
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == "<script src=\"/subsite/js/bootstrap.bundle.min.js\"></script>")
    }

}
