//
// String-Sanitized.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    /// Returns a lowercase string with spaces replaced by hyphens, suitable for use in CSS class names
    var sanitized: String {
        self.lowercased().replacing(" ", with: "-")
    }
}
