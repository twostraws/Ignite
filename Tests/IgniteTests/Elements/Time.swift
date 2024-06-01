//
// Time.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `time` element.
final class TimeTests: ElementTest {
    func test_without_datetime() {
        let element = Time("This is a test")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<time>This is a test</time>")
    }

    func test_builder() {
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
            XCTFail("Failed to create test data!")
            return
        }
        let dateTime = Date(timeIntervalSince1970: customTimeInterval)
        let element = Time(dateTime: dateTime) { "This is a test" }
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<time datetime=\"2024-05-22T20:00:30Z\">This is a test</time>")
    }
}
