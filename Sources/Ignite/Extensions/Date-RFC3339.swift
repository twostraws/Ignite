//
// Date-RFC3339.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Date {
    /// Formats the date as RFC 3339 / ISO 8601, as required by Atom feeds
    /// and JSON Feed.
    ///
    /// - Parameter timeZone: The timezone to use for formatting.
    ///   When `nil`, the current system timezone is used.
    /// - Returns: A string like `"2025-01-15T12:00:00Z"` or
    ///   `"2025-01-15T07:00:00-05:00"`.
    func asRFC3339(timeZone: TimeZone? = nil) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let timeZone { formatter.timeZone = timeZone }
        return formatter.string(from: self)
    }
}
