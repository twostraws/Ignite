//
// NumberFormatter.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

internal struct NumberFormatter {
    /// A number formatter that formats numbers with a single decimal, using the `.` separator. Locale-independent.
    private static let doubleFormatter: Foundation.NumberFormatter = {
        let formatter = Foundation.NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .init(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    /// Formats a double value as a string. Locale-independent.
    static func format(_ value: Double) -> String {
        doubleFormatter.string(for: value) ?? value.formatted()
    }

    /// Formats a percentage value as a string. Locale-independent.
    static func format(_ value: Percentage) -> String {
        doubleFormatter.string(for: value) ?? value.value.formatted()
    }

    /// Formats a float value as a string. Locale-independent
    static func format(_ value: Float) -> String {
        doubleFormatter.string(for: value) ?? value.formatted()
    }
}
