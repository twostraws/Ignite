//
// IgniteRelativePathsTestSuite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
@testable import Ignite

/// A base class for Ignite tests that use `TestRelativePathsSite` with relative paths enabled.
class IgniteRelativePathsTestSuite {
    let site: any Site = TestRelativePathsSite()
    private let fallbackPublishingContext: PublishingContext
    var publishingContext: PublishingContext {
        PublishingContext.current ?? fallbackPublishingContext
    }

    /// Creates a new test instance and initializes the publishing context for `TestRelativePathsSite`.
    init() throws {
        fallbackPublishingContext = try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
    }

    func withPublishingContext<T>(_ operation: () throws -> T) rethrows -> T {
        try PublishingContext.withCurrent(publishingContext, operation: operation)
    }

    func withPublishingContext<T>(
        for site: any Site,
        operation: (PublishingContext) throws -> T
    ) throws -> T {
        try PublishingContext.withInitialized(for: site, from: #filePath, operation: operation)
    }
}

/// A base class for Ignite tests using `TestRelativePathsSubsite` (relative paths with subsite).
class IgniteRelativePathsSubsiteTestSuite {
    let site: any Site = TestRelativePathsSubsite()
    private let fallbackPublishingContext: PublishingContext
    var publishingContext: PublishingContext {
        PublishingContext.current ?? fallbackPublishingContext
    }

    /// Creates a new test instance and initializes the publishing context for `TestRelativePathsSubsite`.
    init() throws {
        fallbackPublishingContext = try PublishingContext.initialize(for: TestRelativePathsSubsite(), from: #filePath)
    }

    func withPublishingContext<T>(_ operation: () throws -> T) rethrows -> T {
        try PublishingContext.withCurrent(publishingContext, operation: operation)
    }

    func withPublishingContext<T>(
        for site: any Site,
        operation: (PublishingContext) throws -> T
    ) throws -> T {
        try PublishingContext.withInitialized(for: site, from: #filePath, operation: operation)
    }

}
