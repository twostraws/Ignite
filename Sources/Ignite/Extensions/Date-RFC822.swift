//
// Date-RFC822.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Date {
    /// Converts `Date` objects to RFC-822 format, which is used by RSS.
    public func asRFC822(timeZone: TimeZone? = nil) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        if let timeZone { formatter.timeZone = timeZone }
        return formatter.string(from: self)
    }
}
