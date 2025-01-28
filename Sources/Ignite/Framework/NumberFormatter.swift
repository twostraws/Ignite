//
// NumberFormatter.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

internal struct NumberFormatter {
    private static let doubleFormatter: Foundation.NumberFormatter = {
        let formatter = Foundation.NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .init(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    static func format(_ value: Double) -> String {
        doubleFormatter.string(for: value) ?? value.formatted()
    }

    static func format(_ value: Percentage) -> String {
        doubleFormatter.string(for: value) ?? value.value.formatted()
    }

    static func format(_ value: Float) -> String {
        doubleFormatter.string(for: value) ?? value.formatted()
    }
}
