//
//  Date-ISO8601.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Date-ISO8601` extension.
@Suite("Date-ISO8601 Tests")
@MainActor
struct DateISO8601Tests {

    struct Instance {
        let input: Date
        let expected: String
    }

    @Test("Known Output", arguments: [
        Instance(input: Date(timeIntervalSince1970: -40241318220), expected: "0694-10-18T00:03:00Z"),
        Instance(input: Date(timeIntervalSince1970: 36571335925), expected: "3128-11-25T08:25:25Z"),
        Instance(input: Date(timeIntervalSince1970: 18980973526), expected: "2571-06-26T04:38:46Z"),
        Instance(input: Date(timeIntervalSince1970: 52003658165), expected: "3617-12-06T04:36:05Z"),
        Instance(input: Date(timeIntervalSince1970: 56358499232), expected: "3755-12-06T10:40:32Z"),
        Instance(input: Date(timeIntervalSince1970: -62133779134), expected: "0001-01-24T00:54:26Z"),
        Instance(input: Date(timeIntervalSince1970: 10439159812), expected: "2300-10-21T14:36:52Z"),
        Instance(input: Date(timeIntervalSince1970: 51288969540), expected: "3595-04-14T07:59:00Z"),
        Instance(input: Date(timeIntervalSince1970: -30827593448), expected: "0993-02-05T03:35:52Z"),
        Instance(input: Date(timeIntervalSince1970: 7109053107), expected: "2195-04-11T16:58:27Z")
    ])
    func outputs_expected_result(instance: Instance) async throws {
        #expect(instance.input.asISO8601 == instance.expected)
    }

    // MARK: - Timezone handling

    @Test("Formats date in UTC")
    func formatsDateInUTC() {
        // 2025-01-15 12:00:00 UTC
        let date = Date(timeIntervalSince1970: 1736942400)
        #expect(date.asISO8601(timeZone: .gmt) == "2025-01-15T12:00:00Z")
    }

    @Test("Formats date with EST timezone")
    func formatsDateWithEST() {
        // 2025-01-15 12:00:00 UTC displayed as EST (-0500)
        let date = Date(timeIntervalSince1970: 1736942400)
        let est = TimeZone(abbreviation: "EST")
        let result = date.asISO8601(timeZone: est)
        #expect(result == "2025-01-15T07:00:00-05:00")
    }

    @Test("Formats epoch zero in UTC")
    func formatsEpochZero() {
        let date = Date(timeIntervalSince1970: 0)
        #expect(date.asISO8601(timeZone: .gmt) == "1970-01-01T00:00:00Z")
    }

    @Test("Defaults to UTC when no timezone specified")
    func defaultsToUTCWhenNoneSpecified() {
        // 2025-01-15 12:00:00 UTC
        let date = Date(timeIntervalSince1970: 1736942400)
        #expect(date.asISO8601() == "2025-01-15T12:00:00Z")
    }
}
