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
@MainActor struct SubsiteScriptTests {
    let publishingContext = ElementTest.publishingSubsiteContext

    @Test("Empty Element", arguments: ["/js/bootstrap.bundle.min.js"])
    func test_empty(script: String) async throws {
        let element = Script(file: script).render(
            context: publishingContext)
        let output = element.render(context: publishingContext)

        #expect(
            output == "<script src=\"/subsite\(script)\"></script>")
    }

}
