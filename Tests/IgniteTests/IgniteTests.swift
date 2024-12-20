//
// IgniteTests.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

// swiftlint:disable force_try
/// A base class that sets up an example publishing context for testing purposes.
@MainActor class ElementTest: XCTestCase {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: #filePath)
    /// A publishing context with sample values for subsite tests.
    let publishingSubsiteContext = try! PublishingContext(for: TestSubsite(), from: #filePath)
}

// swiftlint:enable force_try
