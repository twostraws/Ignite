//
// FormatStyle-NonLocalizedDecimal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>, FormatInput == Double {
    /// A format style that displays a floating point number with one decimal place, enforcing the use of a `.` as the decimal separator.
    static var nonLocalizedDecimal: Self {
        FloatingPointFormatStyle()
            .precision(.fractionLength(1))
            .locale(Locale(identifier: "en_US"))
    }
}

extension FormatStyle where Self == FloatingPointFormatStyle<Float>, FormatInput == Float {
    /// A format style that displays a floating point number with one decimal place, enforcing the use of a `.` as the decimal separator.
    static var nonLocalizedDecimal: Self {
        FloatingPointFormatStyle()
            .precision(.fractionLength(1))
            .locale(Locale(identifier: "en_US"))
    }
}
