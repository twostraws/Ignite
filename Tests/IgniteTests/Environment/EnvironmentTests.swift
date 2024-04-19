//
// EnvironmentTests.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Specific test case that for `@Environment` tests that sets up an example publishing context for testing purposes.
class EnvironmentTests: XCTestCase {
    func test_environment_values() {
        /// A publishing context with sample values.
        let publishingContext = try! PublishingContext(
            for: TestSite(
                homePage: EnvironmentTestPage()
            ),
            rootURL: URL.documentsDirectory
        )

        /// Simulate `PublishingContext` injection as is done during the publication process.
        EnvironmentValues.shared[keyPath: \.context] = publishingContext

        /// Get **HomePage** render output.
        let output = publishingContext.site.homePage.body(context: publishingContext).render(context: publishingContext)

        XCTAssertEqual(output, "<p>My Test Site</p>")
    }
}
