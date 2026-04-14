//
// DateRFC3339.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Date.asRFC3339()` extension.
@Suite("Date RFC 3339 Tests")
struct DateRFC3339Tests {
    @Test("Formats date in UTC")
    func formatsDateInUTC() {
        // 2025-01-15 12:00:00 UTC
        let date = Date(timeIntervalSince1970: 1736942400)
        #expect(date.asRFC3339(timeZone: .gmt) == "2025-01-15T12:00:00Z")
    }

    @Test("Formats date with EST timezone")
    func formatsDateWithEST() {
        // 2025-01-15 12:00:00 UTC displayed as EST (-0500)
        let date = Date(timeIntervalSince1970: 1736942400)
        let est = TimeZone(abbreviation: "EST")
        let result = date.asRFC3339(timeZone: est)
        #expect(result == "2025-01-15T07:00:00-05:00")
    }

    @Test("Formats epoch zero")
    func formatsEpochZero() {
        let date = Date(timeIntervalSince1970: 0)
        #expect(date.asRFC3339(timeZone: .gmt) == "1970-01-01T00:00:00Z")
    }

    @Test("Uses current timezone when none specified")
    func usesCurrentTimezoneWhenNoneSpecified() {
        let date = Date(timeIntervalSince1970: 1736942400)
        let result = date.asRFC3339()
        // Just verify the format is valid RFC 3339 (contains T and timezone offset)
        #expect(result.contains("T"))
        #expect(result.contains("2025-01-15"))
    }
}
