//
// FormatStyle-NonLocalizedDecimal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>, FormatInput == Double {
    /// A format style that displays a floating point number with one decimal place,
    /// enforcing the use of a `.` as the decimal separator.
    static var nonLocalizedDecimal: Self {
        nonLocalizedDecimal(places: 1)
    }

    /// A format style that displays a floating point number enforcing the use of a `.` as the decimal separator.
    /// - Parameter places: The number of decimal places to display. Defaults to 1.
    static func nonLocalizedDecimal(places: Int = 1) -> Self {
        let precision = max(0, places)
        return FloatingPointFormatStyle()
            .precision(.fractionLength(0...precision))
            .locale(Locale(identifier: "en_US"))
    }
}

extension FormatStyle where Self == FloatingPointFormatStyle<Float>, FormatInput == Float {
    /// A format style that displays a floating point number with one decimal place,
    /// enforcing the use of a `.` as the decimal separator.
    static var nonLocalizedDecimal: Self {
        nonLocalizedDecimal(places: 1)
    }

    /// A format style that displays a floating point number enforcing the use of a `.` as the decimal separator.
    /// - Parameter places: The number of decimal places to display. Defaults to 1.
    static func nonLocalizedDecimal(places: Int = 1) -> Self {
        let precision = max(0, places)
        return FloatingPointFormatStyle()
            .precision(.fractionLength(0...precision))
            .locale(Locale(identifier: "en_US"))
    }
}
