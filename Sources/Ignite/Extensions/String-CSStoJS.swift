//
// String-SplitAndTrim.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    /// Converts CSS names to JavaScript names, e.g. box-shadow
    /// becomes boxShadow, background-color becomes backgroundColor.
    /// - Returns: The string with CSS names replaced with JS names
    func convertingCSSNamesToJS() -> String {
        // Split the CSS property name by -.
        let parts = self.split(separator: "-")

        // Capitalize each part except the first.
        let camelCased = parts.enumerated().map { index, part in
            if index == 0 {
                String(part)
            } else {
                part.prefix(1).uppercased() + part.dropFirst()
            }
        }

        // Send back the full, rejoined string as camel case.
        return camelCased.joined()
    }
}
