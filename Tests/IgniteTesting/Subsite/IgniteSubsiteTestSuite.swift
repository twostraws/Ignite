//
// IgniteSubsiteTestSuite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
@testable import Ignite

/// A base class for Ignite tests that manages the lifecycle of `TestSubsite`'s publishing context.
/// - Important: Subclassing is required for suites that test `HTML` elements or modifiers.
@MainActor
class IgniteSubsiteTestSuite {
    let site: any Site = TestSubsite()

    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Creates a new test instance and initializes the publishing context for `TestSubsite`.
    init() throws {
        try PublishingContext.initialize(for: TestSubsite(), from: #filePath)
    }

    /// Resets the publishing context when the test is deallocated.
    deinit {
        Task { @MainActor in
            try? PublishingContext.initialize(for: TestSite(), from: #filePath)
        }
    }
}
