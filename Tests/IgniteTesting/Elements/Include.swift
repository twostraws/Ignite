//
//  Include.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Include` element.
@Suite("Include Tests")
@MainActor
struct IncludeTests {

    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Basic Include")
    func basicInclude() async throws {
        let element = Include("important.html")
        let output = element.render()

        #expect(
            output == "")
    }
}
