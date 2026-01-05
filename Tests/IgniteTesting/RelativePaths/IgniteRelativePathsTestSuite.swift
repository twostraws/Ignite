//
// IgniteRelativePathsTestSuite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
@testable import Ignite

/// A base class for Ignite tests that use `TestRelativePathsSite` with relative paths enabled.
@MainActor
class IgniteRelativePathsTestSuite {
    let site: any Site = TestRelativePathsSite()

    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Creates a new test instance and initializes the publishing context for `TestRelativePathsSite`.
    init() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
    }
}

/// A base class for Ignite tests using `TestRelativePathsSubsite` (relative paths with subsite).
@MainActor
class IgniteRelativePathsSubsiteTestSuite {
    let site: any Site = TestRelativePathsSubsite()

    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Creates a new test instance and initializes the publishing context for `TestRelativePathsSubsite`.
    init() throws {
        try PublishingContext.initialize(for: TestRelativePathsSubsite(), from: #filePath)
    }

    /// Resets the publishing context when the test is deallocated.
    deinit {
        Task { @MainActor in
            try? PublishingContext.initialize(for: TestSite(), from: #filePath)
        }
    }
}
