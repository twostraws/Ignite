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
class IgniteSubsiteTestSuite {
    let site: any Site = TestSubsite()
    private let fallbackPublishingContext: PublishingContext
    var publishingContext: PublishingContext {
        PublishingContext.current ?? fallbackPublishingContext
    }

    /// Creates a new test instance and initializes the publishing context for `TestSubsite`.
    init() throws {
        fallbackPublishingContext = try PublishingContext.initialize(for: TestSubsite(), from: #filePath)
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
