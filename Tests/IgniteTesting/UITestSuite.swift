//
// TestContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
@testable import Ignite

/// A base class for Ignite tests that manages the publishing context lifecycle.
///
/// This class automatically initializes the publishing context with a test site during initialization
/// and cleanup, ensuring each test starts with a fresh context.
@MainActor
class UITestSuite {
    var site: any Site { TestSite() }

    /// Creates a new test instance and initializes the publishing context.
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    /// Resets the publishing context when the test is deallocated.
    deinit {
        Task { @MainActor in
            try? PublishingContext.initialize(for: TestSite(), from: #filePath)
        }
    }
}

class UISubsiteTestSuite: UITestSuite {
    override var site: any Site { TestSubsite() }

    override init() throws {
        try PublishingContext.initialize(for: TestSubsite(), from: #filePath)
    }
}
