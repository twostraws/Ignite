//
// Date-ISO8601.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Date {
    /// Converts `Date` objects to ISO 8601 format in UTC.
    public var asISO8601: String {
        asISO8601()
    }

    /// Formats the date as ISO 8601 / RFC 3339, suitable for HTML `<time>`
    /// elements, Atom feeds, and JSON Feed.
    ///
    /// - Parameter timeZone: The timezone to use for formatting.
    ///   When `nil`, UTC is used and the result ends in `Z`.
    /// - Returns: A string like `"2025-01-15T12:00:00Z"` or
    ///   `"2025-01-15T07:00:00-05:00"`.
    public func asISO8601(timeZone: TimeZone? = nil) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let timeZone { formatter.timeZone = timeZone }
        return formatter.string(from: self)
    }
}
