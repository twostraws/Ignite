//
// Date-RFC822.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Date {
    /// Converts `Date` objects to RFC-822 format, which is used by RSS.
    public var asRFC822: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter.string(from: self)
    }
}
