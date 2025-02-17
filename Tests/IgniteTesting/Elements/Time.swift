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
@MainActor class TimeTests: IgniteTestSuite {
    @Test("Without DateTime", arguments: ["This is a test", "Another test"])
    func withoutDatetime(timeText: String) async throws {
        let element = Time(timeText)
        let output = element.render()

        #expect(output == "<time>\(timeText)</time>")
    }

    @Test("Builder", arguments: ["This is a test", "Another test"])
    func builder(timeText: String) async throws {
        guard
            let customTimeInterval = DateComponents(
                calendar: .current,
                timeZone: .gmt,
                year: 2024,
                month: 5,
                day: 22,
                hour: 20,
                minute: 0,
                second: 30
            ).date?.timeIntervalSince1970
        else {
            Issue.record("Failed to create test data!")
            return
        }
        let dateTime = Date(timeIntervalSince1970: customTimeInterval)
        let element = Time(timeText, dateTime: dateTime)
        let output = element.render()

        #expect(output == "<time datetime=\"2024-05-22T20:00:30Z\">\(timeText)</time>")
    }
}
