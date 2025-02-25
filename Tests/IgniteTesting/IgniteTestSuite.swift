//
// TestContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
@testable import Ignite

/// A base class for Ignite tests that manages the lifecycle of `TestSite`'s publishing context.
///
/// This class automatically initializes the publishing context with a test site during initialization
/// and cleanup, ensuring each test starts with a fresh context.
///
/// - Important: Subclassing is required for suites that test `HTML` elements or modifiers.
@MainActor
class IgniteTestSuite {
    let site: any Site = TestSite()

    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Creates a new test instance and initializes the publishing context for `TestSite`.
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }
}
