//
// Time.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for the `time` element.
@Suite("Time Tests")
struct TimeTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Without DateTime Test")
    func test_without_datetime() async throws {
        let element = Time("This is a test")
        let output = element.render(context: publishingContext)

        #expect(output == "<time>This is a test</time>")
    }
    @Test("Builder Test")
    func test_builder() async throws {
        guard let customTimeInterval = DateComponents(
            calendar: .current,
            timeZone: .gmt,
            year: 2024,
            month: 5,
            day: 22,
            hour: 20,
            minute: 0,
            second: 30
        ).date?.timeIntervalSince1970 else {
            Issue.record("Failed to create test data!")
            return
        }
        let dateTime = Date(timeIntervalSince1970: customTimeInterval)
        let element = Time(dateTime: dateTime) { "This is a test" }
        let output = element.render(context: publishingContext)

        #expect(output == "<time datetime=\"2024-05-22T20:00:30Z\">This is a test</time>")
    }
}
